namespace :facebook do
  desc "Daily harvesting of Facebook postings by user"
  task :harvest_posts => [:environment] do
    Facebook::HarvestPosts.run_all
  end
end
