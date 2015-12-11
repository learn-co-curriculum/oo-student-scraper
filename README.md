# Object Oriented Student Scraper

## Objectives

1. Build two classes, a class that is responsible for scraping data from a web page and a class that uses that data to instantiate new objects. 
3. Understand the contents of a third class that is responsible for the command line interface.
2. Use metaprogramming to instantiate new instances of a class and add attributes to instances of a class. 

## Overview

In this lab, you'll be scraping your Learn.co student website. You'll use the index page to grab a list of current students and instantiate a series of `Student` objects. You'll scrape the individual profile pages of each student to add attributes to each individual student. 

We've given you a third class, `CommandLineInterface` That is responsible for generating students using both the `Student` and `Scraper` classes. As you go through this lab, take some time to read through the code in the `CommandLineInterface` class. Try to understand how it works and how it uses the code in our other classes to actually create, add attributes and display students to the user via the command line interface. 

We've also given you an executable file in `bin/run` that you can execute once you get your tests passing to see your code in action!

## Instructions

### The `Scraper` Class

Let's start with the `Scraper` class in `lib/scraper.rb`. In this class you are responsible for defining two methods. The `#scrape_index_page` method is responsible for scraping the index page that lists all of the students and the `#scrape_profile_page` method is responsible for scraping an individual student's profile page to get further information about that student. 

#### The `#scrape_index_page` Method

This is a class method that should take in an argument of the URL of the index page. It should use nokogiri and Open-URI to access that page. The return value of this method should be an array of hashes in which each hash represent a single student. The keys of the individual student hashes should be `:name`, `:location` and `:profile_url`. 

Here's a look at the desired behavior:

```ruby
Scraper.scrape_index_page(index_url)
# => [
        {:name => "Abby Smith", :location => "Brooklyn, NY", :profile_url => "http://students.learn.co/students/abby-smith.html"},
        {:name => "Joe Jones", :location => "Paris, France", :profile_url => "http://students.learn.co/students/joe-jonas.html"},
        {:name => "Carlos Rodriguez", :location => "New York, NY", :profile_url => "http://students.learn.co/students/carlos-rodriguez.html"},
        {:name => "Lorenzo Oro", :location => "Los Angeles, CA", :profile_url => "http://students.learn.co/students/lorenzo-oro.html"},
        {:name => "Marisa Royer", :location => "Tampa, FL", :profile_url => "http://students.learn.co/students/marisa-royer.html"} 
      ]
```

**Top-Tip:** Remember to use the element inspector in your browser's developer tools to examine each element whose value you are trying to scrape. Also remember to use `binding.pry` and experiment with different element selector in your terminal. It takes a lot of trial and error to find the correct selectors for the desired element.

#### The `#scrape_profile_page` Method

This is a class method that should take in an argument of the profile URL. It should use nokogiri and Open-URI to access that page. The return value of this method should be a hash in which the key/value pairs describe an individual student. Some students don't have a twitter or some other social link. Be sure to be able to handle that. Here is what the hash should look like:

```ruby
Scraper.scrape_profile_page(profile_url)
# => {:twitter=>"http://twitter.com/flatironschool",
      :linkedin=>"https://www.linkedin.com/in/flatironschool",
      :github=>"https://github.com/learn-co,
      :blog=>"http://flatironschool.com",
      :profile_quote=>"\"Forget safety. Live where you fear to live. Destroy your reputation. Be notorious.\" - Rumi",
      :bio=> "I'm a school"
     } 
```

The only attributes you need to scrape from a student's profile page are the ones listed above: twitter url, linkedin url, github url, blog url, profile quote and bio. The hash you build using those attributes should be formatted like the one in the example above. 

**Why class methods?** 

Why are our scraping methods being defined as class methods? Well, we don't need to store any information about the `Scraper` once it has completed the job of scraping. We simply need to scrape some information and pass that information along to our `Student` class. So, we don't need to produce instances of `Scraper` that maintain their own attributes. 

### The `Student` Class

We've already given you the `attr_accessors` that you are required to have for each individual student. 

The student class will use the information returned by the above methods on our `Scraper` class in order to create students and add attributes to individual students. However, the `Student` class shouldn't know about the `Scraper` class. This means that the `Student` class should directly interact with the `Scraper` class––it shouldn't call on the `Scraper` class in any of it's methods or take in the `Scraper` class itself as an argument. Why is this? We want our program to be as flexible as possible. We can imagine any number of applications that use a `Student` model. So, we don't want our `Student` model to be dependent on *how* it gets information regarding the students it creates. It should simply be ready to take in that information, regardless of it's source (be is scraping, a .csv file, or a form on a website). 

#### The `#create_from_collection(students_array)`

This class method should take in an array of hashes. In fact, we will call `Student.create_from_collection` with the return value of the `Scraper.scrape_index_page` method. The `#create_from_collection` method should iterate over the array of hashes and create a new individual student using each hash. This brings us to the `#initialize` method on our `Student` class. 

##### The `#initialize` Method

The `#initialize` method should take in an argument of a hash and use metaprogramming to assign the newly created student attributes and values in accordance with the key/value pairs of the hash. Use the `#send` method to achieve this. This method should also add the newly created student to the `Student` class' `@@all` array of all students. You'll need to create this class variable and set it equal to an empty array at the top of your class. Push `self` into the array at the end of the `#initialize` method. 

#### The `#add_student_attributes` Method 

This instance method should take in a hash whose key/value pairs describe additional attributes of an individual student. In fact, we will be calling `student.add_student_attributes` with the return value of the `Scraper.scrape_profile_page` method. 

The `#add_student_attributes` method should iterate over the given hash and use metaprogramming to dynamically assign the student attributes and values in accordance with the key/value pairs of the hash. Use the `#send` method to achieve this. 

**Important:** The return value of this method should be the student itself. Use the `self` keyword. 

#### The `.all` Method

This class method should return the contents of the `@@all` array. 

### Our Code in Action

Now that you have all your tests passing, you can run our executable file, which relies on our `CommandLineInterface` class. 

**Important:** Our test suite relies on something called stubbing to fake the web requests your code is making in the `Scraper` class. It is not important to understand this right now, just know that we need to do this in the test suite so that we can test all of you students using the same data. In order to run your code with *your real student site* instead of our fake/only-for-testing one, open up `spec/spec_helper` and comment out these two lines:

```ruby
require 'webmock/rspec'  
WebMock.disable_net_connect!(allow_localhost: true) 
```

Now, run the executable file with `ruby bin/run`. You should see all of the students you scraped and instantiated `puts`-ed out to the terminal. Great job!

<a href='https://learn.co/lessons/oo-student-scraper' data-visibility='hidden'>View this lesson on Learn.co</a>
