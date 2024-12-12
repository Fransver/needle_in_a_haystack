FactoryBot.define do
  factory :haystack_tag, class: "NeedleInAHaystack::HaystackTag" do
    sequence(:name) { |n| "Tag #{n}" }
    sequence(:description) { |n| "Description #{n}" }

    trait :root do
      name { "root" }
      description { "Root tag" }
      parent_tag { nil }
    end

    trait :child do
      association :parent_tag, factory: :haystack_tag
    end
  end
end
