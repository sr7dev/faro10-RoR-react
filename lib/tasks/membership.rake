namespace :membership do
  desc "Update Memberships based on Consent changes"
  task :expire => [ :environment ] do
    memberships = Membership.active

    for membership in memberships
      if membership.consents.any?
        consent = membership.consents.order(created_at: :asc).last

        if (Time.now >= consent.ended_at) && (consent.ended_at >= (Time.now - 1.day))

          if membership.update_attributes(status: "inactive")
            puts "membership ##{membership.id} expired by system"
            MembershipMailer.delay.membership_expired_by_system(membership)
          end
        end
      end
    end
  end

  task :warn_expire do
    # TODO: Write Cron task to warn members of expiration
    # Find all memberships that consents end this next week
    # Send email to Clinician and Member
  end
end
