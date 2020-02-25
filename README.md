# Chicano Park history app

Programming I and Programming II Chicano Park collaborative History app. Basic single page app prepped for production.

## Timeline

High-level app prototype by March. Final production-ready version by Global Travel. Currently ahead of schedule. Last updated 2/12/2020.

## Team Members

- Rajan Phadnis
- Evan Mickelson
- Elisse Chow
- Matthew Peng
- Jordan Wood
- Sloane McGuire
- Ishan Seendripu

# App Description

## What

### App purpose

To guide and inform people in and around Chicano Park about the murals and art history within the park
As an exercise in the app development process and cycle

## Why

- Increase awareness of the site and murals
- To make information about Chicano Park more accessible
- Inform the public about tradition/culture of the area
- Inform the public about oppressed groups
- We get experience developing cross-platform apps

## Who

### Target Audience

- Visitors to Chicano Park
- PRS History department

### Target devices

- Cross device support (flutter, pwa, react native, etc)

### Target locations

- Art murals at Chicano park
- Stories behind the murals

### Stakeholders

- Mr. Hobbs
- Programming classes
- History Department/Mr. Peeden
- Chicano Park
- Dr. Bob Ogle

# Feature Feasibility Review

Who will almost always be the user for the application, unless otherwise stated.

## Features

- High priority

  - ✔Provide Offline support to the user in the event the user has no internet connection (as much as possible)✔
    - Why: To stay true to our goal of accessibility
    - Difficulty and Feasibility: Medium-difficulty. Feasible. Using caching and pre-written text, the ability to display information on each mural even when the user is not connected to WiFi, which increases accessibility
  - ✔Have the user use their camera (Image Recognition) to capture, identify and pull up info for a specific mural (complete)✔
    - Why: For an easy, user friendly way of accessing information about the murals.
    - You scan the murals, and it will display information about the scanned mural, maybe in a pop-up type of display.
    - medium difficulty to implement
  - ✔Virtual QR Codes (complete)✔
    - Why: Makes interacting very easy
    - Who
  - ✔Audio tour (complete)✔
    - Why: More accessibility options
    - Very feasible
    - A guided audio tour that will guide visitors around the park in a predetermined route
- Medium priority
  - Predetermined tour routes
    - Why: Accessibility and ease of usage. By having a predetermined route, users can feel less overwhelmed by the park.
    - Feasible, but difficult. Harder than AR
  - ✔App theming (complete)✔ 
    - Why: To make the app “feel,” good for the user.
    - Very feasible
    - Clean color palettes
    - Provide different themes that users can switch between, such as dark and light mode, in order to improve user satisfaction and enjoyability while using the app
  - (deprecated) Map
    - Why: Ease of use, accessibility, way to navigate park.
    - Feasible. Uses Google Maps API and a view to display location on map
  - ✔Gallery Feature (complete)✔
    - Why: Consistent easier way to access knowledge about the park
    - Ability to look through all the murals and their information
- Low Priority
  - Scavenger hunt mode
    - Feasible, but harder AR, easier than a walking tour
  - ✔Social media share integration (complete)
    - Very easy. Native share API
  - Loot boxes (GACHA PLEASE)
  - Popularity and view history
    - Medium feasibility. Relies on syncing to database
