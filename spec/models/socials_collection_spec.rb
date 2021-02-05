require 'rails_helper'

describe SocialsCollection do
  context 'breakdown' do
    it "returns zeros for a single empty day with range of 0" do
      data = [["Sat, 11 May 2013", 0]]

      expect(SocialsCollection.new(data).breakdown).to eq({ "Sat, 11 May 2013" => {"number_of_posts"=>0} })
    end

    it "returns one for a single day with one post with range of 0" do
      data = [["Sat, 11 May 2013", 1]]

      expect(SocialsCollection.new(data).breakdown).to eq({ "Sat, 11 May 2013" => {"number_of_posts"=>1} })
    end

    it "handles three days with one post" do
      data = [
        ["Sat, 11 May 2013", 1],
        ["Sun, 12 May 2013", 1],
        ["Mon, 13 May 2013", 1]
      ]

      expect(
        SocialsCollection.new(data)
        .breakdown)
        .to eq(
          {
            "Sat, 11 May 2013" => {
              "number_of_posts" => 1,
            },
            "Sun, 12 May 2013" => {
              "number_of_posts" => 1,
            },
            "Mon, 13 May 2013" => {
              "number_of_posts" => 1,
            },
          })
    end

    it "handles multiple days and values" do
      data = [
        ["Sat, 11 May 2013", 1],
        ["Sun, 12 May 2013", 2],
        ["Mon, 13 May 2013", 1],
        ["Tue, 14 May 2013", 1],
        ["Wed, 15 May 2013", 2],
        ["Thu, 16 May 2013", 2],
        ["Fri, 17 May 2013", 1],
        ["Sat, 18 May 2013", 5],
        ["Sun, 19 May 2013", 1]
      ]

      expect(
        SocialsCollection.new(data)
        .breakdown)
        .to eq(
          {
            "Sat, 11 May 2013" => {
              "number_of_posts" => 1,
            },
            "Sun, 12 May 2013" => {
              "number_of_posts" => 2,
            },
            "Mon, 13 May 2013" => {
              "number_of_posts" => 1,
            },
            "Tue, 14 May 2013" => {
              "number_of_posts" => 1,
            },
            "Wed, 15 May 2013" => {
              "number_of_posts" => 2,
            },
            "Thu, 16 May 2013" => {
              "number_of_posts" => 2,
            },
            "Fri, 17 May 2013" => {
              "number_of_posts" => 1,
            },
            "Sat, 18 May 2013" => {
              "number_of_posts" => 5,
            },
            "Sun, 19 May 2013" => {
              "number_of_posts" => 1,
            },
          })
    end

    context "with a whole month of data" do
      before(:all) do
        data = [
          ["Sun, 01 May 2011", 3],
          ["Mon, 02 May 2011", 6],
          ["Tue, 03 May 2011", 5],
          ["Wed, 04 May 2011", 5],
          ["Thu, 05 May 2011", 2],
          ["Fri, 06 May 2011", 1],
          ["Sat, 07 May 2011", 7],
          ["Sun, 08 May 2011", 1],
          ["Mon, 09 May 2011", 0],
          ["Tue, 10 May 2011", 0],
          ["Wed, 11 May 2011", 4],
          ["Thu, 12 May 2011", 3],
          ["Fri, 13 May 2011", 4],
          ["Sat, 14 May 2011", 8],
          ["Sun, 15 May 2011", 0],
          ["Mon, 16 May 2011", 7],
          ["Tue, 17 May 2011", 3],
          ["Wed, 18 May 2011", 15],
          ["Thu, 19 May 2011", 19],
          ["Fri, 20 May 2011", 22],
          ["Sat, 21 May 2011", 25],
          ["Sun, 22 May 2011", 3],
          ["Mon, 23 May 2011", 6],
          ["Tue, 24 May 2011", 5],
          ["Wed, 25 May 2011", 5],
          ["Thu, 26 May 2011", 2],
          ["Fri, 27 May 2011", 1],
          ["Sat, 28 May 2011", 7],
        ]
        @subject = SocialsCollection.new(data).breakdown
      end

      it "handles the non-avg dates" do
        expect(@subject["Sun, 01 May 2011"]).to eq({ "number_of_posts" => 3 })
        expect(@subject["Mon, 02 May 2011"]).to eq({ "number_of_posts" => 6 })
        expect(@subject["Tue, 03 May 2011"]).to eq({ "number_of_posts" => 5 })
        expect(@subject["Wed, 04 May 2011"]).to eq({ "number_of_posts" => 5 })
        expect(@subject["Thu, 05 May 2011"]).to eq({ "number_of_posts" => 2 })
        expect(@subject["Fri, 06 May 2011"]).to eq({ "number_of_posts" => 1 })
        expect(@subject["Sat, 07 May 2011"]).to eq({ "number_of_posts" => 7 })
        expect(@subject["Sun, 08 May 2011"]).to eq({ "number_of_posts" => 1 })
        expect(@subject["Mon, 09 May 2011"]).to eq({ "number_of_posts" => 0 })
        expect(@subject["Tue, 10 May 2011"]).to eq({ "number_of_posts" => 0 })
        expect(@subject["Wed, 11 May 2011"]).to eq({ "number_of_posts" => 4 })
        expect(@subject["Thu, 12 May 2011"]).to eq({ "number_of_posts" => 3 })
        expect(@subject["Fri, 13 May 2011"]).to eq({ "number_of_posts" => 4})
        expect(@subject["Sat, 14 May 2011"]).to eq({ "number_of_posts" => 8})
      end

      it "handles prior to variance" do
        expect(@subject["Sun, 15 May 2011"]).to eq({ "number_of_posts" => 0, "current_avg" => 3.28571})
      end

      it "handles mild up" do
        expect(@subject["Mon, 16 May 2011"]).to eq({ "number_of_posts" => 7, "current_avg" => 3.35714, "variance" => "mild_up"})
      end

      it "handles average" do
        expect(@subject["Tue, 17 May 2011"]).to eq({ "number_of_posts" =>3, "current_avg" => 3.21429, "variance" => "average"})
      end

      it "it handles severe up" do
        expect(@subject["Wed, 18 May 2011"]).to eq({ "number_of_posts" => 15, "current_avg" => 3.92857, "variance" => "severe_up"})
      end
    end
  end
end
