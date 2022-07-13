/*  Script by Dimas Febriyanto
    Contact:
      Instagram: @dimassfeb
      Email: dimassfeb@gmail.com
      Youtube: https://www.youtube.com/channel/UC40Kkddz7dIbOwzp0tYDmfg
*/

import 'dart:async';
import 'package:twitter_api_v2/twitter_api_v2.dart' as v2;
import 'package:cron/cron.dart';

void main() async {
  // Settings What You Want

  String minute, hours, days, month, week;
  String BEARER_TOKEN,
      CUSTOMER_KEY,
      CUSTOMER_SECRET,
      ACCESS_TOKEN,
      ACCESS_TOKEN_SECRET;

  // CRON AUTO RUN SETTING, or you can visit https://crontab.guru/
  // Fill * if you don't need settings
  minute = "1"; // Enter Minute
  hours = "*"; // Enter Hourse
  days = "*"; // Enter Days
  month = "*"; // Enter Month
  week = "*"; // Enter week

  String cronDateTime =
      "*/$minute $hours $days $month $week"; // Please don't change

  // SETTING TO WITH DEVELOPER ACCOUNT TWITTER
  BEARER_TOKEN =
      "AAAAAAAAAAAAAAAAAAAAADUBPwEAAAAAZi%2FUlj4G2hKWijnZ%2FvkLCG0Wgy4%3DqgGplVXyncqogvY3eH194mqhgiBjJS0c4MUdOOAXM7kirePDyb"; // Fill your Bearer Token
  CUSTOMER_KEY = "njSPlrcEq6Y43XHHNCAtnbImU"; // Fill your API KEY
  CUSTOMER_SECRET =
      "PmLR4pxrywr4jquN9zqFw1LDKR65HWRYkc1sTTKEBuv8fqBTsR"; // Fill your API Secret
  ACCESS_TOKEN =
      "1117371474183016450-JxIUmWsXIsFjqfnGJYtaDLovtTJe5n"; // Fill your Access Token
  ACCESS_TOKEN_SECRET =
      "qZylrhr1lFsxGpbr2PMsTtI6MxA55waGaTUHyM2Wvig3Z"; // Fill your Access Token Secret

  // SETTING USER IDS
  List<String> userIds = [
    "1331650559518990336",
    "1205629250423779328",
  ]; // You can Fill userIds

  // SETTING AUTO REPLY
  String textReply = "I'll give you recommendation, please dm me if you want";

  final cron = Cron();
  cron.schedule(
    Schedule.parse('$cronDateTime'),
    () async {
      final twitter = v2.TwitterApi(
        bearerToken: BEARER_TOKEN,
        oauthTokens: v2.OAuthTokens(
          consumerKey: CUSTOMER_KEY,
          consumerSecret: CUSTOMER_SECRET,
          accessToken: ACCESS_TOKEN,
          accessTokenSecret: ACCESS_TOKEN_SECRET,
        ),
        timeout: Duration(minutes: 1),
      );

      try {
        final me = await twitter.usersService.lookupMe();

        List dataTweetId = []; // Don't change

        // Looping Data dari UserIds untuk mencari Tweet dari List of userIds
        for (var i = 0; i < userIds.length; i++) {
          final searchTweetById = await twitter.tweetsService.lookupTweets(
            userId: userIds[i],
            maxResults: 5,
          );

          // Looping dan memasukkan data ke dalam dataTweetId
          for (var i = 0; i < searchTweetById.data.length; i++) {
            dataTweetId.add(searchTweetById.data[i].id);
          }
        }

        String linkTweet = "";

        for (var i = 0; i < dataTweetId.length; i++) {
          final commentTweetById = await twitter.tweetsService.createTweet(
            text: textReply,
            reply: v2.TweetReplyParam(
              inReplyToTweetId: dataTweetId[i],
            ),
          );
        }

        // Catch (e)
      } on TimeoutException catch (e) {
        print(e);
      } on v2.RateLimitExceededException catch (e) {
        print(e);
      } on v2.TwitterException catch (e) {
        print(e.response.headers);
        print(e.body);
        print(e);
      }
    },
  );
}
