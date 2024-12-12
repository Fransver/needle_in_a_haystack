namespace :needle_in_a_haystack do
  desc "Import the configured Haystack ontology into the database"
  task import_ontology: :environment do
    NeedleInAHaystack::HaystackOntology.import_full_ontology
    puts "Imported #{NeedleInAHaystack::HaystackTag.count} Haystack tags."
  end
end
