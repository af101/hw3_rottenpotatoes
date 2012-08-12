# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    if (!Movie.find_by_title(movie["title"]))
      m=Movie.create!(:title=>movie["title"],
                      :rating=>movie["rating"],
                      :release_date=>movie["release_date"])
    end
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp=/#{e1}.*#{e2}/m
  page.body.should =~ regexp
  #  page.content  is the entire content of the page as a string.
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do |x|
    x.gsub!(/\"/,'')
    if(uncheck)
      step %{I uncheck "ratings_#{x}"}
    else
      step %{I check "ratings_#{x}"}
    end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

When /I (un)?check all the ratings/ do |un|
  step %{I #{un}check the following ratings: #{Movie.all_ratings * ","}}
end

Then /I should see these movies: (.*)/ do |csv_movie_list|
  csv_movie_list.split(",").each do |movie|
    step %{I should see #{movie}}
  end
end

Then /I should see no movie at all/ do
  page.body.should_not =~ /More about/
end

Then /I should see all of the movies/ do
  page.body.scan(/More about/).length.should == Movie.all.length
end

Then /I should not see these movies: (.*)/ do |csv_movie_list|
  csv_movie_list.split(",").each do |movie|
    step %{I should not see #{movie}}
  end
end
