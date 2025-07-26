# CalcuLock - First Pass Implementation Explanation

## Overview

CalcuLock is an iPhone app prototype that allows users to block specific apps for a set duration. The only way to unblock apps early is by solving calculus problems. This implementation provides a basic functional prototype with core features.

## Architecture

The app follows a standard iOS MVC (Model-View-Controller) pattern with UIKit and is designed specifically for iPhone. The implementation consists of several key components:

### Core Files

#### 1. `Info.plist`
The standard iOS application property list file that defines:
- App bundle information (name, identifier, version)
- Required device capabilities (iPhone-specific)
- Supported interface orientations
- Scene configuration for iOS 13+ scene-based architecture
- App Transport Security settings

#### 2. `AppDelegate.swift`
The main application delegate that:
- Serves as the entry point for the app (`@main` attribute)
- Handles application lifecycle events
- Configures scene sessions for iOS 13+ multi-scene support
- Minimal implementation focusing on delegation to SceneDelegate

#### 3. `SceneDelegate.swift`
Manages the app's UI scenes and window:
- Creates the main window for the app
- Instantiates the root view controller (`ViewController`)
- Wraps it in a `UINavigationController` for navigation support
- Handles scene lifecycle events (foreground/background transitions)

### Main User Interface

#### 4. `ViewController.swift` (Main Screen)
The primary interface where users interact with blocking functionality:

**Core Properties:**
- `blockedApps`: Set of app names selected for blocking
- `blockEndTime`: Timestamp when blocking period ends
- `appCategories`: Dictionary mapping category names to app lists
- `blockDurations`: Array of predefined blocking durations (15 min to 8 hours)

**UI Components:**
- Title label displaying "CalcuLock"
- Status label showing current blocking state
- App selection button to choose which apps to block
- Duration picker for selecting blocking time
- Start/stop blocking buttons
- Category management button

**Key Methods:**
- `updateUI()`: Refreshes interface based on current blocking state
- `selectAppsButtonTapped()`: Opens app selection interface
- `startBlockButtonTapped()`: Initiates blocking with selected duration
- `unblockButtonTapped()`: Opens calculus solver for early unblocking

**Picker Implementation:**
Implements `UIPickerViewDataSource` and `UIPickerViewDelegate` to allow users to select blocking duration from predefined options.

#### 5. `AppSelectionViewController.swift`
Dedicated screen for selecting which apps to block:

**Functionality:**
- Displays list of mock apps in a table view
- Uses checkmarks to indicate selected apps
- Maintains selection state in a Set
- Provides callback mechanism to update main controller

**Implementation Details:**
- Uses `UITableView` with custom cell configuration
- Toggle selection on tap with visual feedback
- "Done" button to confirm selection and return to main screen

### Calculus Challenge System

#### 6. `CalculusViewController.swift`
The core blocking bypass mechanism:

**UI Components:**
- Problem display label showing calculus questions
- Answer input field for user responses
- Submit button to check answers
- Hint button for problem assistance
- New problem button to generate different questions
- Cancel button to return without unblocking

**CalculusProblem Struct:**
- `question`: The calculus problem text
- `answer`: Expected answer (string or numeric)
- `hint`: Help text for the problem
- `tolerance`: Acceptable numeric error range
- `checkAnswer()`: Validates user input against correct answer

**Problem Types:**
- Basic derivatives (power rule, trigonometric functions)
- Simple integrals
- Exponential and logarithmic derivatives
- Each problem includes educational hints

**Answer Validation:**
- Supports both exact string matching and numeric tolerance
- Case-insensitive string comparison
- Floating-point comparison with configurable tolerance

### Category Management

#### 7. `CategoriesViewController.swift`
Manages app organization into categories:

**Default Categories:**
- Social Media: Instagram, TikTok, Facebook, etc.
- Entertainment: YouTube, Netflix, Spotify
- Messaging: WhatsApp, Telegram, Discord
- Games: Generic games category
- Browsers: Safari, Chrome

**Functionality:**
- Add new custom categories
- Edit existing categories (add/remove apps)
- Delete categories with confirmation
- Persistent category storage during app session

#### 8. `CategoryDetailViewController.swift`
Detailed view for managing individual categories:

**Features:**
- Display all apps in a specific category
- Add apps from available list
- Remove apps with swipe-to-delete
- Real-time updates to parent category list

### Project Configuration

#### 9. `.gitignore`
Comprehensive Git ignore file for iOS projects:
- Xcode user data and build artifacts
- Derived data and temporary files
- Package manager dependencies (CocoaPods, Carthage)
- FastLane generated files
- macOS system files (.DS_Store)

## How It Works

### 1. App Selection Flow
1. User taps "Select Apps to Block"
2. `AppSelectionViewController` presents list of available apps
3. User toggles checkmarks to select/deselect apps
4. Tapping "Done" returns to main screen with selections saved

### 2. Blocking Process
1. User selects blocking duration using picker wheel
2. User taps "Start Blocking" button
3. App calculates end time based on current time + selected duration
4. UI updates to show blocking status and remaining time
5. "Solve Calculus to Unblock" button becomes available

### 3. Unblocking Process
1. User taps "Solve Calculus to Unblock"
2. `CalculusViewController` presents random calculus problem
3. User enters answer and submits
4. If correct: blocking ends immediately and user returns to main screen
5. If incorrect: user can try again, get hints, or generate new problem

### 4. Category Management
1. User taps "Manage Categories"
2. `CategoriesViewController` shows existing categories
3. User can add new categories or edit existing ones
4. Within category detail, user can add/remove specific apps
5. Changes are saved and reflected in main app selection

## Testing the Project

### Prerequisites
- Xcode 12.0 or later
- iOS 14.0+ deployment target
- iPhone simulator or physical device

### Setting Up the Project
1. Create a new iOS project in Xcode
2. Replace the default files with the provided implementation files
3. Ensure all Swift files are added to the project target
4. Set the deployment target to iOS 14.0+
5. Configure the bundle identifier in project settings

### Basic Testing Scenarios

#### 1. App Selection Testing
- Launch the app
- Tap "Select Apps to Block"
- Select/deselect various apps
- Verify checkmarks appear/disappear correctly
- Tap "Done" and verify main screen shows correct count

#### 2. Blocking Functionality Testing
- Select at least one app to block
- Choose different blocking durations using the picker
- Tap "Start Blocking"
- Verify status label updates with end time
- Verify "Start Blocking" button becomes hidden
- Verify "Solve Calculus to Unblock" button appears

#### 3. Calculus Solver Testing
- Start a blocking session
- Tap "Solve Calculus to Unblock"
- Try entering wrong answers (should show "Incorrect" alert)
- Use "Show Hint" button to get help
- Try "New Problem" to generate different questions
- Enter correct answer to verify unblocking works

#### 4. Category Management Testing
- Tap "Manage Categories"
- Verify default categories are present
- Add a new category
- Edit existing categories by adding/removing apps
- Delete a category and confirm deletion
- Verify changes persist within the session

### Known Limitations

1. **Mock Data**: App uses hardcoded list of apps instead of actual installed apps
2. **No Persistence**: Data doesn't persist between app launches
3. **No Actual Blocking**: This is a UI prototype - doesn't actually block other apps
4. **Basic Validation**: Limited input validation for calculus answers
5. **No Scheduling**: Time-based scheduling feature not implemented
6. **No Daily Limits**: App usage time limits not implemented

### Next Steps for Development

1. Integrate with iOS Screen Time API for actual app blocking
2. Implement Core Data for persistent storage
3. Add more sophisticated calculus problem generation
4. Implement scheduling system
5. Add daily usage tracking and limits
6. Improve UI/UX with animations and better visual design
7. Add accessibility features
8. Implement proper error handling and edge cases

## File Structure Summary

```
CalcuLock/
├── Info.plist                           # App configuration
├── AppDelegate.swift                    # App lifecycle management
├── SceneDelegate.swift                  # Scene and window management
├── ViewController.swift                 # Main interface
├── AppSelectionViewController.swift     # App selection interface
├── CalculusViewController.swift         # Calculus problem solver
├── CategoriesViewController.swift       # Category management
├── first_pass_explanation.md           # This documentation
└── .gitignore                          # Git ignore rules
```

This implementation provides a solid foundation for the CalcuLock concept and demonstrates all core functionality in a working iOS prototype.