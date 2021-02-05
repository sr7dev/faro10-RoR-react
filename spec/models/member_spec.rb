require 'rails_helper'

describe Member do
  # describe "validations" do
  #   it "should have valid validations" do
  #     should validate_inclusion_of(:gender).in_array(%w(Male Female))
  #   end
  # end

  describe "relationships" do
    it "should have valid relationships" do
      should have_many(:alerts)
      should have_many(:appointments)
      should have_many(:clinicians)
      should have_many(:clinician_entries)
      should have_many(:dsm_diagnoses).class_name("Diagnosis")
      should have_many(:icd_diagnoses).class_name("Diagnosis")
      should have_many(:entries)
      should have_many(:entries_prescriptions)
      should have_many(:entries_symptoms)
      should have_many(:memberships)
      should have_many(:messages)
      should have_many(:observers)
      should have_many(:observations_on_me).class_name("Observation")
      should have_many(:observees)
      should have_many(:observations_of_others).class_name("Observation")
      should have_many(:observer_entries)
      should have_many(:observer_entries_on_me)
      should have_many(:prescriptions)
      should have_many(:symptoms)
      should have_many(:tracked_symptoms).class_name("TrackedSymptom")
      should have_many(:tracked_symptom_symptoms).class_name("Symptom")
      should have_many(:active_observations_on_me)
        .class_name("Observation")
        .conditions(status: "Active")
      #should have_many(:active_observers)
        #.through(:active_observations_on_me)
        #.with_foreign_key(:observer_id)
      #should have_many(:observee_prescriptions)

    end
  end

  describe "#observer_journal_entries" do
    it "should return observer entries on me where journal is not nil" do
      member = create(:member)
      mother = create(:member)
      observation = create(:observation, member_id: member.id, observer: mother)
      journal_entry =create(
        :observer_entry,
        observation: observation,
        observer: mother,
        observee: member
      )
      blank_entry = create(
        :observer_entry,
        observation: observation,
        observer: mother,
        observee: member,
        journal: nil
      )

      expect(member.observer_journal_entries.count).to eq(1)
      expect(member.observer_journal_entries).to include(journal_entry)
      expect(member.observer_journal_entries).not_to include(blank_entry)
    end
  end

  describe '.connected_to_facebook?' do
    context 'unconnected Member' do
      let!(:unconnected_member) { create(:member) }

      it "returns false" do
        expect(unconnected_member.connected_to_facebook?).to be_falsy
      end
    end

    context 'connected Member' do
      let!(:connected_member) { create(:connected_member) }

      it "returns truthy" do
        expect(connected_member.connected_to_facebook?).to be_truthy
      end
    end
  end

  # describe "#avg_med_consistency" do
  #   it "should return the avg of unexperience prescription consistency" do
  #     member = setup_prescriptions_member
  #
  #     expect(member.avg_med_consistency).to eq(1)
  #   end
  # end

  describe "#drugs_by_name_and_dosage" do
    it "should return an array of friendly names for my drug prescriptions" do
      member = setup_prescriptions_member

      expect(member.drugs_by_name_and_dosage).to contain_exactly(["Advil", 24])
    end
  end

  describe "#feelings_sum" do
    it "should return the sum of all entries grouped by their created date" do
      member = setup_entries_member

      expect(member.feelings_sum).to eq(
        Date.new(2017, 10, 1) => 5,
        Date.new(2017, 10, 2) => 8,
        Date.new(2017, 10, 3) => 3,
      )
    end
  end

  describe "#feelings_avg" do
    it "should return the average of all entries on a given date" do
      member = setup_entries_member
      create(
        :entry,
        member: member,
        zest: 9,
        pessimism: 3,
        energy: 3,
        anxiety: 6,
        headache: 4,
        feeling: 3,
        created_at: Date.new(2017, 10, 2)
      )

      expect(member.feelings_avg).to eq(
        Date.new(2017, 10, 1) => 5.0,
        Date.new(2017, 10, 2) => 5.5,
        Date.new(2017, 10, 3) => 3.0,
      )
    end
  end

  describe "#recent_entries" do
    it "should return and array of all enntries created in the last 2 weeks" do
      travel_to Date.new(2017, 10, 10) do
        member = setup_entries_member
        late_entry = create(
          :entry,
          member: member,
          zest: 9,
          pessimism: 3,
          energy: 3,
          anxiety: 6,
          headache: 4,
          feeling: 3,
          created_at: Date.new(2017, 7, 2)
        )

        expect(member.recent_entries.count).to eq(3)
        expect(member.recent_entries).not_to include(late_entry)
      end
    end
  end

  def setup_prescriptions_member
    member = create(:member)
    prescription = create(
      :prescription,
      :advil,
      member_id: member.id,
    )
    entry = create(:entry, member: member)
    EntriesPrescription.create(
      entry: entry,
      prescription: prescription,
      times_taken: 1,
      day_taken: Date.new(2017, 6, 1),
    )
    EntriesPrescription.create(
      entry: entry,
      prescription: prescription,
      times_taken: 0,
      day_taken: Date.new(2017, 6, 2),
    )

    member
  end

  def setup_entries_member
    member = setup_prescriptions_member

    create(
      :entry,
      member: member,
      zest: 9,
      pessimism: 3,
      energy: 3,
      anxiety: 6,
      headache: 4,
      feeling: 8,
      created_at: Date.new(2017, 10, 2)
    )

    create(
      :entry,
      member: member,
      zest: 2,
      pessimism: 4,
      energy: 6,
      anxiety: 8,
      headache: 7,
      feeling: 3,
      created_at: Date.new(2017, 10, 3)
    )

    member
  end
end
