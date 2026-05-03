# Flutter Project Structure: Feature-first or

# Layer-first?

```
#dart #flutter #app-architecture
```
```
Andrea Bizzotto
Mar 23, 2022 9 min read
```
#### When building large Flutter apps, one of the first things we should decide is how to

#### structure our project.

#### This ensures that the entire team can follow a clear convention and add features in a

#### consistent manner.

#### So in this article we'll explore two common approaches for structuring our project:

#### feature-first and layer-first.

#### We'll learn about their tradeoffs and identify common pitfalls when trying to

#### implement them on real-world apps. And we'll wrap up with a clear step-by-step guide

#### for how you can structure your project, avoiding costly mistakes along the way.

## Project Structure in Relation to App Architecture

#### In practice, we can only choose a project structure once we have decided what app

#### architecture to use.

#### This is because app architecture forces us to define separate layers with clear

#### boundaries. And those layers will show up somewhere as folders in our project.

##### CODE WITH ANDREA


#### So for the rest of this article, we'll use my Riverpod App Architecture as a reference:

```
Flutter App Architecture using data, domain, application, and presentation layers.
```

#### This architecture is made of four distinct layers , each containing the components that

#### our app needs:

- **presentation** : widgets, states, and controllers
- **application** : services
- **domain** : models
- **data** : repositories, data sources, and DTOs (data transfer objects)

#### Of course, if we're building just a single-page app, we can put all files in one folder and

#### call it a day. 😎

#### But as soon as we start adding more pages and have various data models to deal with,

#### how can we organize all our files in a consistent way?

#### In practice, a feature-first or layer-first approach is often used.

#### So let's explore these two conventions in more detail and learn about their tradeoffs.

## Layer-first (features inside layers)

#### To keep things simple, suppose we have only two features in the app.

#### If we adopt the layer-first approach, our project structure may look like this:


```
‣ lib
‣ src
‣ presentation
‣ feature
‣ feature
‣ application
‣ feature
‣ feature
‣ domain
‣ feature
‣ feature
‣ data
‣ feature
‣ feature
```
#### With this approach, we can add all the relevant Dart files inside each feature folder,

#### ensuring that they belong to the correct layer (widgets and controllers inside

#### presentation , models inside domain , etc.).

#### And if we want to add feature3 , we need to add a feature3 folder inside each

#### layer and repeat the process:

#### Strictly speaking, this is a "features inside layers" approach, as we don't put our

#### Dart files directly inside each layer, but create folders inside them instead.


```
‣ lib
‣ src
‣ presentation
‣ feature
‣ feature
‣ feature3 <--
‣ application
‣ feature
‣ feature
‣ feature3 <-- only create this when needed
‣ domain
‣ feature
‣ feature
‣ feature3 <--
‣ data
‣ feature
‣ feature
‣ feature3 <--
```
### Layer-first: Drawbacks

#### This approach is easy to use in practice, but doesn't scale very well as the app grows.

#### For any given feature, files that belong to different layers are far away from each other.

#### And this makes it harder to work on individual features because we have to keep

#### jumping to different parts of the project.

#### And if we decide that we want to delete a feature, it's far too easy to forget certain files,

#### because they are all organized by layer.

#### For these reasons, the feature-first approach is often a better choice when building

#### medium/large apps.

## Feature-first (layers inside features)


#### The feature-first approach demands that we create a new folder for every new feature

#### that we add to our app. And inside that folder, we can add the layers themselves as sub-

#### folders.

#### Using the same example as above, we would organize our project like this:

```
‣ lib
‣ src
‣ features
‣ feature
‣ presentation
‣ application
‣ domain
‣ data
‣ feature
‣ presentation
‣ application
‣ domain
‣ data
```
#### I find this approach more logical because we can easily see all the files that belong to a

#### certain feature, grouped by layer.

#### In comparison to the layer-first approach, there are some advantages:

- whenever we want to add a new feature or modify an existing one, we can focus on

#### just one folder.

- if we want to delete a feature, there's only one folder to remove (two if we count the

#### corresponding tests folder)

#### So it would appear that the feature-first approach wins hands down! 🙌

#### However, things are not so easy in the real world.


## What about shared code?

#### Of course, when building real apps you'll find that your code doesn't always fit neatly

#### into specific folders as you intended.

#### What if two or more separate features need to share some widgets or model classes?

#### In these cases, it's easy to end up with folders called shared or common , or utils.

#### But how should these folders themselves be organized? And how do you prevent them

#### from becoming a dumping ground for all sorts of files?

#### If your app has 20 features and has some code that needs to be shared by only two of

#### them, should it really belong to a top-level shared folder?

#### What if it's shared among 5 features? Or 10?

#### In this scenario, there is no right or wrong answer, and you have to use your best

#### judgement on a case-by-case basis.

#### Aside from this, there is a very common mistake that we should avoid.

## Feature-first is not about the UI!

#### When we focus on the UI, we're likely to think of a feature as a single page or screen in

#### the app.

#### I made this mistake myself while building the eCommerce app for my upcoming Flutter

#### course.

#### And I ended up with was a project structure that looked a bit like this:


```
‣ lib
‣ src
‣ features
‣ account
‣ admin
‣ checkout
‣ leave_review_page
‣ orders_list
‣ product_page
‣ products_list
‣ shopping_cart
‣ sign_in
```
#### All the features above represented actual screens in the eCommerce app.

#### But when it came to putting the presentation , application , domain , and data layers

#### inside them, I ran into trouble because some models and repositories were shared by

#### multiple pages (such as the product_page and product_list ).

#### As a result, I ended up creating top-level folders for services , models , and repositories :

```
‣ lib
‣ src
‣ features
‣ account
‣ admin
‣ checkout
‣ leave_review_page
‣ orders_list
‣ product_page
‣ products_list
‣ shopping_cart
‣ sign_in
‣ models <-- should this go here?
‣ repositories <-- should this go here?
‣ services <-- should this go here?
```

#### In other words, I had applied a feature-first approach to the features folder, which

#### represented my entire presentation layer. But I cornered myself into a layer-first

#### approach for the remaining layers, and this influenced my project structure in an

#### unintended way.

## What is a "feature"?

#### So I took a step back and asked myself: "what is a feature"?

#### And I realized it's not about what the user sees , but what the user does :

- authenticate
- manage the shopping cart
- checkout
- view all past orders
- leave a review

#### In other words, a feature is a functional requirement that helps the user complete a

#### given task.

#### And taking some hints from domain-driven design , I decided to organize the project

#### structure around the domain layer.

#### Once I figured that out, everything fell into place. And I ended up with seven functional

#### areas:

#### Do not attempt to apply a feature-first approach by looking at the UI. This will

#### result in an "unbalanced" project structure that will bite you later on.


```
‣ lib
‣ src
‣ features
‣ address
‣ application
‣ data
‣ domain
‣ presentation
‣ authentication
...
‣ cart
...
‣ checkout
...
‣ orders
...
‣ products
‣ application
‣ data
‣ domain
‣ presentation
‣ admin
‣ product_screen
‣ products_list
‣ reviews
...
```
#### Note that with this approach is still possible for code inside a given feature to depend

#### on code from a different feature. For example:

- the product page shows a list of **reviews**
- the orders page shows some **product** information
- the checkout flow requires the user to **authenticate** first

#### But we end up with far fewer files that are shared across all features , and the entire


#### structure is much more balanced.

## How to do feature-first, the right way

#### In summary, the feature-first approach lets us structure our project around the

#### functional requirements of our app.

#### So here's how to use this correctly in your own apps:

- start from the **domain layer** and identify the model classes and business logic for

#### manipulating them

- create a folder for each model (or group of models) that **belong together**
- within that folder, create the presentation , application , domain , data

#### sub-folders as needed

- inside each sub-folder, add all the files you need

#### For reference, here's how my final project structure ended up:

#### When building Flutter apps, it's very common to have a ratio of 5:1 (or more)

#### between UI code and business logic. If your presentation folder ends up with

#### many files, don't be afraid to group them into sub-folders that represent smaller

#### "sub-features".


```
‣ lib
‣ src
‣ common_widgets
‣ constants
‣ exceptions
‣ features
‣ address
‣ authentication
‣ cart
‣ checkout
‣ orders
‣ products
‣ reviews
‣ localization
‣ routing
‣ utils
```
#### Without even looking inside folders such as common_widgets, constants ,

#### exceptions , localization , routing , and utils , we can guess that they all

#### contain code that is truly shared across features, or needs to be centralized for a good

#### reason (such as localization and routing).

#### And these folders all contain relatively little code.

## Bonus: the test folder

#### I haven't talked about this until now. But it makes a lot of sense for the test folder to

#### follow the same project structure as the lib folder.

#### And this is very easy to do by using the "Go to Tests" option in VSCode:


```
VSCode option to Go to Tests from any file in the "lib" folder
```
#### For any given file inside lib, this will create a _test.dart file in the corresponding

#### location inside test. 👍

## Conclusion

#### When done right, going feature-first has many benefits over layer-first.

#### Having built a medium-sized eCommerce app of 10K LOC with it, I'm confident that this

#### is a scalable approach that should work well for bigger codebases.

#### Of course, when building very large apps we will face additional constraints. And at

#### some point, we may need to mix and match different approaches, or even break up the

#### codebase into multiple packages that live in a single monorepo.

#### But if we apply domain-driven design from the start, we'll end up with clear boundaries

#### between the different layers and components of our app. And this will make

#### dependencies more manageable later on.

#### And if you want to learn more about app architecture and the role of each individual

#### layer, check the other articles in this series:


- Flutter App Architecture with Riverpod: An Introduction
- Flutter App Architecture: The Repository Pattern
- Flutter App Architecture: The Domain Model
- Flutter App Architecture: The Application Layer
- Flutter App Architecture: The Presentation Layer

## Flutter Foundations Course Now Available

#### I launched a brand new course that covers Flutter app architecture in great depth,

#### along with other important topics like state management, navigation & routing, testing,

#### and much more:

### Flutter Foundations Course

```
INTERMEDIATE TO ADVANCED
Learn about State Management, App Architecture, Navigation,
Testing, and much more by building a Flutter eCommerce app on
iOS, Android, and web.
```

### Want More?

#### Invest in yourself with my high-quality Flutter courses.

### Flutter In Production

```
INTERMEDIATE TO ADVANCED
Learn about flavors, environments, error
monitoring, analytics, release
management, CI/CD, and finally ship
your Flutter apps to the stores. 🚀
```
### Flutter & Firebase

### Masterclass

```
INTERMEDIATE TO ADVANCED
Learn about Firebase Auth, Cloud
Firestore, Cloud Functions, Stripe
payments, and much more by building a
full-stack eCommerce app with Flutter &
Firebase.
```

### The Complete Dart

### Developer Guide

BEGINNER

Learn Dart Programming in depth.
Includes: basic to advanced topics,
exercises, and projects. Last updated to
Dart 2.15.

### Flutter Animations

### Masterclass

```
INTERMEDIATE
Master Flutter animations and build a
completely custom habit tracking
application.
```
##### CODE WITH ANDREA

```
Copyright © 2020-present Coding With Flutter Limited
```
```
Contact
```
```
Twitter
```
```
Discord
```
```
GitHub
```
```
RSS
```

```
Meta
```
Privacy Policy

```
Terms of Use
```

