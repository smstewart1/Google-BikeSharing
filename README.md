# Google-BikeSharing
In this capstone project I looked at the profiles of casual vs subscriber bike rental customers at a fictional company in Chicago.  Key findings included that most casual riders returned their bikes where the originally picked the up, and were mostly centered near the park in downtown.  Subscribers were the opposite - they dropped their bikes off at a different location than where they started and were located more in the city proper.

Below is a map of the distribution of bike rentals in the city, with casual riders in blue and members in orange.  A copy of the full dashboard can be found here https://public.tableau.com/app/profile/stephen.stewart4198/viz/GoogleDataAnalytics-RideSharing/RideSharingSummary#1

![RentalLocations](https://github.com/smstewart1/Google-BikeSharing/assets/107202785/d1eb2185-96ca-437b-95de-8d6dd553a8fd)

R was used to clean the data as the files were too large for Excel to really handle, especially after compositing.  Inner joins were used in tableau to pair the bike rental locations with their geographic location using data sets provided by the company.
