# Testing Report: TailWaggr

This report summarizes the testing activities performed for **TailWaggr**. The goal of these tests was to ensure the stability, functionality, and performance of the software.

## Test Scope

The following components were tested:
- **Frontend**: User Interface, Form Validation, Navigation
- **Backend**: API responses, Database interactions
- **Security**: Authentication, Authorization, Data Validation

## Types of Testing

- **Unit Testing**: Testing of individual functions and methods.
- **Integration Testing**: Ensured that modules work together as expected.
- **Performance Testing**: Tested the application under load to assess speed and reliability using Google lighthouse.
- **UI Testing**: Verification of the user interface components across different devices and browsers.

## Testing Tools
- [Widget Test](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Integration Testing](https://flutter.dev/docs/cookbook/testing/integration/introduction)
- [Mockito](https://pub.dev/packages/mockito)
- [LightHouse](https://developers.google.com/web/tools/lighthouse)

## Links to our testing files

### UI Tests
- [Forum Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/forum_test.dart)
- [Homepage Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/homePage_test.dart)
- [Location Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/location_test.dart)
- [Login Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/login_test.dart)
- [Lost and Found Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/lostandfound_test.dart)
- [Notifications Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/notifications_test.dart)
- [Sign up Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/signup_test.dart)
- [Profile Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/user_profile_test.dart)

### Integration Tests
- [Integration Testing](https://github.com/COS301-SE-2024/TailWaggr/blob/main/cos301_capstone/test/integration_test.dart)


## Test Results Summary

- [GitHub Actions Build Results](https://github.com/COS301-SE-2024/TailWaggr/actions)

- **Total Tests Conducted**: 65
- **Tests Passed**: 61
- **Tests Failed**: 4

## Forum Test Cases
<table>
<tr>
    <th>Test ID</th>
    <th>Description</th>
    <th>Actual Result</th>
    <th>Status</th>
</tr>
<tr>
    <td>TC-01</td>
    <td>displays the message and user profile correctly</td>
    <td>As expected</td>
    <td>Passed</td>
</tr>
<tr>
    <td>TC-02</td>
    <td>displays replies correctly</td>
    <td>As expected</td>
    <td>Passed</td>
</tr>
<tr>
    <td>TC-03</td>
    <td>shows TextField for typing reply</td>
    <td>As expected</td>
    <td>Passed</td>
</tr>
<tr>
    <td>TC-04</td>
    <td>displays the correct user name</td>
    <td>As expected</td>
    <td>Passed</td>
</tr>
</table>

## Homepage Test Cases
<table>
  <tr>
    <th>Test ID</th>
    <th>Description</th>
    <th>Actual Result</th>
    <th>Status</th>
  </tr>
  <tr>
    <td>TC-01</td>
    <td>Displays basic information</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-02</td>
    <td>Displays pet information</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-03</td>
    <td>Displays like, comment, and view counts</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td colspan="4"><strong>Desktop</strong></td>
  </tr>
  <tr>
    <td>TC-04</td>
    <td>Check post container for Desktop</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-05</td>
    <td>Should display pets list and allow selection</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-06</td>
    <td>Should display error when trying to post without text</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-07</td>
    <td>Should display error when no image is selected</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-08</td>
    <td>Check post container for Desktop</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-09</td>
    <td>Should display post text input and add post text</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td colspan="4"><strong>Tablet</strong></td>
  </tr>
  <tr>
    <td>TC-04</td>
    <td>Check post container for Tablet</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-05</td>
    <td>Should display pets list and allow selection</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-06</td>
    <td>Should display error when trying to post without text</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-07</td>
    <td>Should display error when no image is selected</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-08</td>
    <td>Check post container for Tablet</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-09</td>
    <td>Should display post text input and add post text</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td colspan="4"><strong>Mobile</strong></td>
  </tr>
  <tr>
    <td>TC-04</td>
    <td>Check post container for Mobile</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-05</td>
    <td>Should display pets list and allow selection</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-06</td>
    <td>Should display error when trying to post without text</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-07</td>
    <td>Should display error when no image is selected</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-08</td>
    <td>Check post container for Mobile</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-09</td>
    <td>Should display post text input and add post text</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
</table>

## Location Test Cases
<table>
  <tr>
    <th>Test ID</th>
    <th>Description</th>
    <th>Actual Result</th>
    <th>Status</th>
  </tr>
  <tr>
    <td>TC-01</td>
    <td>LocationDesktop widget test</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-02</td>
    <td>Testing the Vets Tab for Desktop</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-03</td>
    <td>LocationTablet widget test</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
  <tr>
    <td>TC-04</td>
    <td>Testing the Vets Tab for Tablet</td>
    <td>As expected</td>
    <td>Passed</td>
  </tr>
    <tr>
        <td>TC-05</td>
        <td>LocationMobile widget test</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-06</td>
        <td>Testing the Vets Tab for Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
</table>

## Login Test Cases
<table>
    <tr>
        <th>Test ID</th>
        <th>Description</th>
        <th>Actual Result</th>
        <th>Status</th>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Renders DesktopLogin and UI components</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>Toggles password visibility Desktop</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-03</td>
        <td>Renders TabletLogin and UI components</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-04</td>
        <td>Toggles password visibility Tablet</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-05</td>
        <td>Renders MobileLogin and UI components</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
</table>

## Lost and Found Test Cases
<table>
    <tr>
        <th>Test ID</th>
        <th>Description</th>
        <th>Actual Result</th>
        <th>Status</th>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Displays basic components for Desktop</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>Testing clicking a pet and viewing the sightings</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-03</td>
        <td>Displays basic components for Tablet</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-04</td>
        <td>Testing clicing a pet and viewing the sightings</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
</table>

## Notifications Test Cases
<table>
    <tr>
        <th>Test ID</th>
        <th>Description</th>
        <th>Actual Result</th>
        <th>Status</th>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Desktop Notifications builds correctly</td>
        <td>Found 0 widgets with key [<'loading-notifications'>]</td>
        <td>Failed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>Desktop Notification Card builds correctly</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
</table>

## Sign up Test Cases
<table>
    <tr>
        <th>Test ID</th>
        <th>Description</th>
        <th>Actual Result</th>
        <th>Status</th>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Renders Desktop Signup and UI components</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>Toggles password visibility Desktop</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-03</td>
        <td>Enters data into each text field Desktop</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-04</td>
        <td>Renders Mobile Signup and UI components</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-05</td>
        <td>Toggles password visibility Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-06</td>
        <td>Enters data into each text field Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
</table>

## User Profile Test Cases
<table>
    <tr>
        <th>Test ID</th>
        <th>Description</th>
        <th>Actual Result</th>
        <th>Status</th>
    </tr>
    <tr>
        <td colspan="4"><strong>Desktop</strong></td>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Testing the PostsContainer widget for Desktop</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>Testing the ListOfPosts widget for Desktop</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-03</td>
        <td>Testing the AboutMeContainer widget for Desktop</td>
        <td>Found 0 widgets with text "John Doe"</td>
        <td>Failed</td>
    </tr>
    <tr>
        <td>TC-04</td>
        <td>Testing the MyPetsContainer widget for Deskto</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-05</td>
        <td>Testing the PetProfileButton widget for Desktop</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td colspan="4"><strong>Tablet</strong></td>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Testing the PostsContainer widget for Tablet</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>Testing the ListOfPosts widget for Tablet</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-03</td>
        <td>Testing the AboutMeContainer widget for Tablet</td>
        <td>Found 0 widgets with text "John Doe"</td>
        <td>Failed</td>
    </tr>
    <tr>
        <td>TC-04</td>
        <td>Testing the MyPetsContainer widget for Tablet</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-05</td>
        <td>Testing the PetProfileButton widget for Tablet</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td colspan="4"><strong>Mobile</strong></td>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Testing the PostsContainer widget for Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>Testing the ListOfPosts widget for Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-03</td>
        <td>Testing the AboutMeContainer widget for Mobile</td>
        <td>Found 0 widgets with text "John Doe"</td>
        <td>Failed</td>
    </tr>
    <tr>
        <td>TC-04</td>
        <td>Testing the MyPetsContainer widget for Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-05</td>
        <td>Testing the PetProfileButton widget for Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
</table>

## Integration Test Cases
<table>
    <tr>
        <th>Test ID</th>
        <th>Description</th>
        <th>Actual Result</th>
        <th>Status</th>
    </tr>
    <tr>
        <td>TC-01</td>
        <td>Enters data into each text field Mobile</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-02</td>
        <td>getPetById returns pet data if exists</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-03</td>
        <td>deleteImageFromStorage deletes image successfully</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-04</td>
        <td>getUserDetails returns user data if exists</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-05</td>
        <td>getPetProfile returns pet data if exists</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-06</td>
        <td>updatePetProfile updates pet data successfully</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
    <tr>
        <td>TC-07</td>
        <td>deletePetProfile deletes pet data successfully</td>
        <td>As expected</td>
        <td>Passed</td>
    </tr>
</table>