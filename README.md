# Code_from_Macintosh_Programming_Secrets_1988

Code from the first edition of the book "Macintosh Programming Secrets", by Scott Knaster.

The examples are written in Pascal, and run in MPW.

You can find the first edition on [Vintage Apple - Mac Programming](https://vintageapple.org/macprogramming/)

There is also a second edition (1992), which has code examples in C. Repo for that book coming shortly.

### Using Think Pascal

The libraries differ in Think Pascal and so you need to change the `uses` line to
```none
 uses
{$LOAD Insider:MPW:Pinterfaces:Allinterfaces}
{$U Insider:MPW:Pinterfaces:MemTypes.p }
{MemTypes,}
  Memory, 
 {$U Insider:MPW:Pinterfaces:QuickDraw.p}
{QuickDraw,}
  QuickDraw, 
 {$U Insider:MPW:Pinterfaces:OSintf.p }
{OSintf,}
  OSUtils, OSEvents, 
 {$U Insider:MPW:Pinterfaces:Toolintf.p }
{Toolintf,}
  ToolUtils, 
 {$U Insider:MPW:Pinterfaces:Packintf.p }
{Packintf;}
  Packages;
```
or just
```none
 uses
  Memory, QuickDraw, OSutils, OSEvents, ToolUtils, Packages;
```

See also:

- [Inside Macintosh Links](https://gr33nonline.wordpress.com/2024/04/24/inside-macintosh-links/)
- [Source code for Macintosh Programming Secrets (1998)](https://gr33nonline.wordpress.com/2024/04/26/source-code-for-macintosh-programming-secrets-1998/)
  
---

Other Macintosh related repos:

- greenonline/[Creation_from_Programmers_Guide_to_MPW_1990](https://github.com/greenonline/Creation_from_Programmers_Guide_to_MPW_1990)
- greenonline/[Bug_fixes_for_the_hundredrabbits_repo](https://github.com/greenonline/Bug_fixes_for_the_hundredrabbits_repo)
- greenonline/[Code_from_Macintosh_Programming_Secrets_1988](https://github.com/greenonline/Code_from_Macintosh_Programming_Secrets_1988)
- greenonline/[Code_from_Macintosh_Programming_Secrets_1992]()
- Others:
  - [hundredrabbits](https://github.com/hundredrabbits)/[Macintosh-Cookbook](https://github.com/hundredrabbits/Macintosh-Cookbook) (read only)
  - [https://git.sr.ht/~rabbits/macintosh-cookbook/tree/master](https://git.sr.ht/~rabbits/macintosh-cookbook/tree/master)

