import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Sinflix'**
  String get appName;

  /// Login page title - Merhabalar in English
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get loginTitle;

  /// Login page description text
  ///
  /// In en, this message translates to:
  /// **'Tempus varius a vitae interdum id\ntortor elementum tristique eleifend at.'**
  String get loginDescription;

  /// Register page title - Hoşgeldiniz in English
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get registerTitle;

  /// Register page description text
  ///
  /// In en, this message translates to:
  /// **'Tempus varius a vitae interdum id tortor\nelementum tristique eleifend at.'**
  String get registerDescription;

  /// Terms and conditions text on register page
  ///
  /// In en, this message translates to:
  /// **'I have read and accept the user agreement. Please read this agreement to continue.'**
  String get termsAndConditions;

  /// Register button text - Şimdi Kaydol
  ///
  /// In en, this message translates to:
  /// **'Register Now'**
  String get registerNow;

  /// Login action text - Giriş Yap!
  ///
  /// In en, this message translates to:
  /// **'Login!'**
  String get loginNow;

  /// Register action text - Kayıt Ol!
  ///
  /// In en, this message translates to:
  /// **'Register!'**
  String get registerNowAction;

  /// Not implemented message
  ///
  /// In en, this message translates to:
  /// **'This feature is not ready yet'**
  String get notImplementedYet;

  /// Email required error message
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Password required error message
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Name required error message
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Confirm password required error message
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get confirmPasswordRequired;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Email input label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password input label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Name input label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get name;

  /// Confirm password input label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// Don't have account text on login page
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Already have account text on register page
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Privacy first part
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the '**
  String get termsPrefix;

  /// Privacy link
  ///
  /// In en, this message translates to:
  /// **'user agreement'**
  String get termsLinkText;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Privacy last part
  ///
  /// In en, this message translates to:
  /// **'. Please read this agreement to continue.'**
  String get termsSuffix;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Favorites tab label
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Discover tab label
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// Movies section title
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// Loading indicator text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Generic error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No data message
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noData;

  /// Pull to refresh instruction
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get pullToRefresh;

  /// Load more button text
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// Add to favorites button text
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// Remove from favorites button text
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// No favorites message title
  ///
  /// In en, this message translates to:
  /// **'No favorite movies yet'**
  String get noFavorites;

  /// No favorites message description
  ///
  /// In en, this message translates to:
  /// **'You can add movies you like to favorites'**
  String get noFavoritesDesc;

  /// Profile photo label
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// Change photo button text
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// Upload photo button text
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// Camera option text
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Gallery option text
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Notifications setting label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// About menu item
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Limited offer title
  ///
  /// In en, this message translates to:
  /// **'Limited Offer'**
  String get limitedOffer;

  /// Special offer description
  ///
  /// In en, this message translates to:
  /// **'Choose a token package to earn bonus and unlock new episodes!'**
  String get specialOfferDesc;

  /// Get bonuses section title
  ///
  /// In en, this message translates to:
  /// **'Your Bonuses'**
  String get getBonuses;

  /// Premium account bonus
  ///
  /// In en, this message translates to:
  /// **'Premium Account'**
  String get premiumAccount;

  /// More interaction bonus
  ///
  /// In en, this message translates to:
  /// **'More Matches'**
  String get moreInteraction;

  /// Unlock features bonus
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get unlockFeatures;

  /// More likes bonus
  ///
  /// In en, this message translates to:
  /// **'More Likes'**
  String get moreLikes;

  /// Unlock episode instruction
  ///
  /// In en, this message translates to:
  /// **'Choose a token package to unlock'**
  String get unlockEpisode;

  /// View all tokens button
  ///
  /// In en, this message translates to:
  /// **'View All Tokens'**
  String get viewAllTokens;

  /// Weekly offers text
  ///
  /// In en, this message translates to:
  /// **'Per week'**
  String get weeklyOffers;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// Registration success message
  ///
  /// In en, this message translates to:
  /// **'Registration successful'**
  String get registerSuccess;

  /// Logout success message
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get logoutSuccess;

  /// Photo upload success message
  ///
  /// In en, this message translates to:
  /// **'Photo uploaded'**
  String get photoUploadSuccess;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get errorNetwork;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later'**
  String get errorServer;

  /// Invalid credentials error
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get errorInvalidCredentials;

  /// User already exists error
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get errorUserExists;

  /// Email validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get errorValidationEmail;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorValidationPassword;

  /// Name validation error
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get errorValidationName;

  /// Password match validation error
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get errorValidationPasswordMatch;

  /// Photo upload error
  ///
  /// In en, this message translates to:
  /// **'Error occurred while uploading photo'**
  String get errorPhotoUpload;

  /// Photo size error
  ///
  /// In en, this message translates to:
  /// **'Photo size is too large'**
  String get errorPhotoSize;

  /// Photo format error
  ///
  /// In en, this message translates to:
  /// **'Unsupported photo format'**
  String get errorPhotoFormat;

  /// Session expired message
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please login again'**
  String get sessionExpired;

  /// Unauthorized access message
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for this action'**
  String get unauthorized;

  /// Yes button text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// OK button text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Profile detail text
  ///
  /// In en, this message translates to:
  /// **'Profile Detail'**
  String get profileDetail;

  /// Movies i like text
  ///
  /// In en, this message translates to:
  /// **'Movies I Like'**
  String get moviesILike;

  /// You don't have any favorite movies yet text
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any favorite movies yet.'**
  String get noFavoriteMovies;

  /// Movies could not loaded text
  ///
  /// In en, this message translates to:
  /// **'Movies could not loaded'**
  String get moviesCouldNotLoaded;

  /// Text shown to indicate more content is available, typically used as a link to view additional details.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// Label for the movie description section in the movie details bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for the section containing detailed movie information such as year, genre, and runtime.
  ///
  /// In en, this message translates to:
  /// **'Movie Details'**
  String get movieDetails;

  /// Label for the movie release year in the movie details section.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// Label for the movie genre in the movie details section.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// Label for the movie duration in the movie details section.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get runtime;

  /// Label for the movie rating (e.g., PG-13) in the movie details section.
  ///
  /// In en, this message translates to:
  /// **'Rated'**
  String get rated;

  /// Label for the movie's country of origin in the movie details section.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Label for the movie release date in the movie details section.
  ///
  /// In en, this message translates to:
  /// **'Released'**
  String get released;

  /// Label for the section listing the movie's director, writer, and actors.
  ///
  /// In en, this message translates to:
  /// **'Cast & Crew'**
  String get castAndCrew;

  /// Label for the movie director in the cast and crew section.
  ///
  /// In en, this message translates to:
  /// **'Director'**
  String get director;

  /// Label for the movie writer in the cast and crew section.
  ///
  /// In en, this message translates to:
  /// **'Writer'**
  String get writer;

  /// Label for the movie actors in the cast and crew section.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get cast;

  /// Label for the section containing movie ratings and awards information.
  ///
  /// In en, this message translates to:
  /// **'Ratings & Awards'**
  String get ratingsAndAwards;

  /// Label for the IMDb rating of the movie in the ratings and awards section.
  ///
  /// In en, this message translates to:
  /// **'IMDb Rating'**
  String get imdbRating;

  /// Label for the Metascore rating of the movie in the ratings and awards section.
  ///
  /// In en, this message translates to:
  /// **'Metascore'**
  String get metascore;

  /// Label for the awards received by the movie in the ratings and awards section.
  ///
  /// In en, this message translates to:
  /// **'Awards'**
  String get awards;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
