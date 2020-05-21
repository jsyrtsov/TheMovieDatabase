
# TheMovieDatabase

It's an app where you can find out about popular, upcoming and now playing movies, watch trailers, also you can see the cast and the crew of the movie and person's details. Application uses TMDB API. [See API](https://developers.themoviedb.org/3/getting-started/introduction) for details.


## Overview

Codestyle enforced by SwiftLint.
Used as less as possible third party libraries, only when it's neccessary.
All pull request are reviewed. 

**Features:**

1. List of Popular, Upcoming, Now Playing movies.
2. List of Favorite movies (using Realm if user don't have account and using guest mode).
3. Search.
4. Detailed screen of the movie with overview, videos, cast and crew.
5. Detailed screen of the person with overview, images (with image viewer), credits.
6. Both landscape and portrait modes on every iPhone model are supported.
7. Authorization for users who have account on TMDB and fully working guest mode for those who don't.
8. Handle network errors and showing AlertController with errors' description (for example user entered wrong password).

## Preview

Here is short GIF preview which demonstrates design and features of the App.

<p align="center">
	<img src="Images/longVersion.gif" />
</p>
