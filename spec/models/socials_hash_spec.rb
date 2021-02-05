require 'rails_helper'

describe SocialsHash do
  describe "#from_dates" do
    context "empty hash" do
      let(:member) { create(:member) }

      it "handles empty hash" do
        expect(SocialsHash.new(member, Date.today - 1, Date.today + 1).data).to eq({})
      end
    end

    context "with a single post on relevant day" do
      let(:member) { create(:member) }

      it "procures fifteen days back with a post" do
        new_time = Time.local(2009, 9, 1, 12, 0, 0)
        Timecop.freeze(new_time) do
          create(:facebook_post, created_time: DateTime.now, user: member)
          expect(SocialsHash.new(member, Date.today - 1, Date.today + 1).data).to eq(
            {
              "Sun, 16 Aug 2009"=>0,
              "Mon, 17 Aug 2009"=>0,
              "Tue, 18 Aug 2009"=>0,
              "Wed, 19 Aug 2009"=>0,
              "Thu, 20 Aug 2009"=>0,
              "Fri, 21 Aug 2009"=>0,
              "Sat, 22 Aug 2009"=>0,
              "Sun, 23 Aug 2009"=>0,
              "Mon, 24 Aug 2009"=>0,
              "Tue, 25 Aug 2009"=>0,
              "Wed, 26 Aug 2009"=>0,
              "Thu, 27 Aug 2009"=>0,
              "Fri, 28 Aug 2009"=>0,
              "Sat, 29 Aug 2009"=>0,
              "Sun, 30 Aug 2009"=>0,
              "Mon, 31 Aug 2009"=>0,
              "Tue, 01 Sep 2009"=>1
            }
          )

        end
      end

      it "gets all the dates even with a gap" do
        new_time = Time.local(2009, 9, 1, 12, 0, 0)
        Timecop.freeze(new_time) do
          create(:facebook_post, created_time: DateTime.now + 5.days , user: member)
          expect(SocialsHash.new(member, Date.today - 20, Date.today + 10.days).data).to eq(
            {
              "Tue, 28 Jul 2009"=>0,
              "Wed, 29 Jul 2009"=>0,
              "Thu, 30 Jul 2009"=>0,
              "Fri, 31 Jul 2009"=>0,
              "Sat, 01 Aug 2009"=>0,
              "Sun, 02 Aug 2009"=>0,
              "Mon, 03 Aug 2009"=>0,
              "Tue, 04 Aug 2009"=>0,
              "Wed, 05 Aug 2009"=>0,
              "Thu, 06 Aug 2009"=>0,
              "Fri, 07 Aug 2009"=>0,
              "Sat, 08 Aug 2009"=>0,
              "Sun, 09 Aug 2009"=>0,
              "Mon, 10 Aug 2009"=>0,
              "Tue, 11 Aug 2009"=>0,
              "Wed, 12 Aug 2009"=>0,
              "Thu, 13 Aug 2009"=>0,
              "Fri, 14 Aug 2009"=>0,
              "Sat, 15 Aug 2009"=>0,
              "Sun, 16 Aug 2009"=>0,
              "Mon, 17 Aug 2009"=>0,
              "Tue, 18 Aug 2009"=>0,
              "Wed, 19 Aug 2009"=>0,
              "Thu, 20 Aug 2009"=>0,
              "Fri, 21 Aug 2009"=>0,
              "Sat, 22 Aug 2009"=>0,
              "Sun, 23 Aug 2009"=>0,
              "Mon, 24 Aug 2009"=>0,
              "Tue, 25 Aug 2009"=>0,
              "Wed, 26 Aug 2009"=>0,
              "Thu, 27 Aug 2009"=>0,
              "Fri, 28 Aug 2009"=>0,
              "Sat, 29 Aug 2009"=>0,
              "Sun, 30 Aug 2009"=>0,
              "Mon, 31 Aug 2009"=>0,
              "Tue, 01 Sep 2009"=>0,
              "Wed, 02 Sep 2009"=>0,
              "Thu, 03 Sep 2009"=>0,
              "Fri, 04 Sep 2009"=>0,
              "Sat, 05 Sep 2009"=>0,
              "Sun, 06 Sep 2009"=>1
            }
          )
        end
      end
    end
  end
end
