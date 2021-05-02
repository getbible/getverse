## HOW TO USE THIS SCRIPT

**You can call it directly with a query like this:**

```bash
/bin/bash <(/bin/curl -s https://raw.githubusercontent.com/getbible/getverse/master/src/chapter.sh) "John 3:16-18"
```
Will return:
```text
16 For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.
17 For God sent not his Son into the world to condemn the world; but that the world through him might be saved.
18 He that believeth on him is not condemned: but he that believeth not is condemned already, because he hath not believed in the name of the only begotten Son of God.
```
> each verse per line, with the line number as the first value in the line.

**Other translations, use as a second argument the abbreviation of the translation.**

```bash
/bin/bash <(/bin/curl -s https://raw.githubusercontent.com/getbible/getverse/master/src/chapter.sh) "John 3:16-18" textusreceptus
```
Will return:
```
16 ουτως γαρ ηγαπησεν ο θεος τον κοσμον ωστε τον υιον αυτου τον μονογενη εδωκεν ινα πας ο πιστευων εις αυτον μη αποληται αλλ εχη ζωην αιωνιον 
17 ου γαρ απεστειλεν ο θεος τον υιον αυτου εις τον κοσμον ινα κρινη τον κοσμον αλλ ινα σωθη ο κοσμος δι αυτου 
18 ο πιστευων εις αυτον ου κρινεται ο δε μη πιστευων ηδη κεκριται οτι μη πεπιστευκεν εις το ονομα του μονογενους υιου του θεου 
```
> each verse per line, with the line number as the first value in the line.

```bash
/bin/bash <(/bin/curl -s https://raw.githubusercontent.com/getbible/getverse/master/src/chapter.sh) "John 3:16-18" korean
```
Will return:
```
16 하나님이 세상을 이처럼 사랑하사 독생자를 주셨으니 이는 저를 믿는 자마다 멸망치 않고 영생을 얻게 하려 하심이니라 
17 하나님이 그 아들을 세상에 보내신 것은 세상을 심판하려 하심이 아니요 저로 말미암아 세상이 구원을 받게 하려 하심이라 
18 저를 믿는 자는 심판을 받지 아니하는 것이요 믿지 아니하는 자는 하나님의 독생자의 이름을 믿지 아니하므로 벌써 심판을 받은 것이니라 
```
> each verse per line, with the line number as the first value in the line.


Each translation book names in the query is critical, and can be found in the API:
```text
https://getbible.net/v2/korean/books.json
```
Each translation can possibly have its own translated names like:
```text
https://getbible.net/v2/aov/books.json
```

Here is a list of [translations](https://github.com/getbible/v2/blob/master/translations.json) available.

#### Todo

- validate queries
- Increase the various ways to query verses
- Add more return formats
- Increase the speed of the returned text

## Free Software

```text
Llewellyn van der Merwe <github@vdm.io>
Copyright (C) 2019. All Rights Reserved
GNU/GPL Version 2 or later - http://www.gnu.org/licenses/gpl-2.0.html
```
