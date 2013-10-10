Feature: Signing in
  scenario: Unsuccessful signin
    Given a user visits the signin page
    When he submits invalid signin credentials
    Then he should see an error message

  scenario: Successful signin
    Given a user visits the signin page
     And  the user has an account
    When  the user submits the valid signin credentials
    Then  he should see his profile page
     And  he should see a signout link