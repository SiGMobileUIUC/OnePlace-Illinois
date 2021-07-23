// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/cupertino.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:oneplace_illinois/src/onePlace.dart';
// import 'package:oneplace_illinois/src/widgets/sliverView.dart';

void main() {
  /*
  Naming method:
    Given some context, When some action is carried out, Then a set of observable consequences take place.
  */

  // Check if icons in tabs are showing correct page.
  testWidgets(
      "Given user in current tab When other tab bar item is pressed Then a new tab is opened.",
      (WidgetTester tester) async {
    // Assemble

    /* late PlatformIcons platformIcons;

    await tester.pumpWidget(Builder(builder: (context) {
      platformIcons = PlatformIcons(context);
      return PlatformApp(
        home: OnePlaceTabs(),
      );
    }));

    final libraryTab = find.byIcon(platformIcons.book);
    final feedTab = find.byIcon(platformIcons.home);
    final addItemTab = find.byIcon(platformIcons.addCircledOutline);

    expect(libraryTab, findsOneWidget);
    expect(feedTab, findsOneWidget);
    expect(addItemTab, findsOneWidget);

    // Act
    await tester.tap(libraryTab);
    await tester.pumpAndSettle();

    // Assert
    final libraryTitle = find.byWidgetPredicate(
        (widget) => widget is SliverView && widget.title == "Library");
    expect(libraryTitle, findsOneWidget);

    // Act
    await tester.tap(feedTab);
    await tester.pumpAndSettle();

    // Assert
    final feedTitle = find.byWidgetPredicate(
        (widget) => widget is SliverView && widget.title == "Feed");
    expect(feedTitle, findsOneWidget);

    // Act
    await tester.tap(addItemTab);
    await tester.pumpAndSettle();

    // Assert
    final addItemTitle = find.byWidgetPredicate(
        (widget) => widget is SliverView && widget.title == "New Item");
    expect(addItemTitle, findsOneWidget); */
  });
}
