﻿CKEDITOR.plugins.add('mobilepictogram',{requires:['dialog'],lang:['en','ja'],init:function(a){a.addCommand('mobilepictogram',new CKEDITOR.dialogCommand('mobilepictogram'));a.ui.addButton('MobilePictogram',{label:a.lang.mobilepictogram.toolbar,command:'mobilepictogram',icon:this.path+'img/mobilepictogram.gif'});CKEDITOR.dialog.add('mobilepictogram',this.path+'dialogs/mobilepictogram.js');}});CKEDITOR.config.mobilepictogram_path=CKEDITOR.basePath+'plugins/mobilepictogram/images/';CKEDITOR.config.mobilepictogram_images=['sun.gif','cloud.gif','rain.gif','snow.gif','thunder.gif','typhoon.gif','mist.gif','sprinkle.gif','aries.gif','taurus.gif','gemini.gif','cancer.gif','leo.gif','virgo.gif','libra.gif','scorpius.gif','sagittarius.gif','capricornus.gif','aquarius.gif','pisces.gif','sports.gif','baseball.gif','golf.gif','tennis.gif','soccer.gif','ski.gif','basketball.gif','motorsports.gif','pocketbell.gif','train.gif','subway.gif','bullettrain.gif','car.gif','rvcar.gif','bus.gif','ship.gif','airplane.gif','house.gif','building.gif','postoffice.gif','hospital.gif','bank.gif','atm.gif','hotel.gif','24hours.gif','gasstation.gif','parking.gif','signaler.gif','toilet.gif','restaurant.gif','cafe.gif','bar.gif','beer.gif','fastfood.gif','boutique.gif','hairsalon.gif','karaoke.gif','movie.gif','upwardright.gif','carouselpony.gif','music.gif','art.gif','drama.gif','event.gif','ticket.gif','smoking.gif','nosmoking.gif','camera.gif','bag.gif','book.gif','ribbon.gif','present.gif','birthday.gif','telephone.gif','mobilephone.gif','memo.gif','tv.gif','game.gif','cd.gif','heart.gif','spade.gif','diamond.gif','club.gif','eye.gif','ear.gif','rock.gif','scissors.gif','paper.gif','downwardright.gif','upwardleft.gif','foot.gif','shoe.gif','eyeglass.gif','wheelchair.gif','newmoon.gif','moon1.gif','moon2.gif','moon3.gif','fullmoon.gif','dog.gif','cat.gif','yacht.gif','xmas.gif','downwardleft.gif','phoneto.gif','mailto.gif','faxto.gif','info01.gif','info02.gif','mail.gif','by-d.gif','d-point.gif','yen.gif','free.gif','id.gif','key.gif','enter.gif','clear.gif','search.gif','new.gif','flag.gif','freedial.gif','sharp.gif','mobaq.gif','one.gif','two.gif','three.gif','four.gif','five.gif','six.gif','seven.gif','eight.gif','nine.gif','zero.gif','ok.gif','heart01.gif','heart02.gif','heart03.gif','heart04.gif','happy01.gif','angry.gif','despair.gif','sad.gif','wobbly.gif','up.gif','note.gif','spa.gif','cute.gif','kissmark.gif','shine.gif','flair.gif','annoy.gif','punch.gif','bomb.gif','notes.gif','down.gif','sleepy.gif','sign01.gif','sign02.gif','sign03.gif','impact.gif','sweat01.gif','sweat02.gif','dash.gif','sign04.gif','sign05.gif','slate.gif','pouch.gif','pen.gif','shadow.gif','chair.gif','night.gif','soon.gif','on.gif','end.gif','clock.gif','appli01.gif','appli02.gif','t-shirt.gif','moneybag.gif','rouge.gif','denim.gif','snowboard.gif','bell.gif','door.gif','dollar.gif','pc.gif','loveletter.gif','wrench.gif','pencil.gif','crown.gif','ring.gif','sandclock.gif','bicycle.gif','japanesetea.gif','watch.gif','think.gif','confident.gif','coldsweats01.gif','coldsweats02.gif','pout.gif','gawk.gif','lovely.gif','good.gif','bleah.gif','wink.gif','happy02.gif','bearing.gif','catface.gif','crying.gif','weep.gif','ng.gif','clip.gif','copyright.gif','tm.gif','run.gif','secret.gif','recycle.gif','r-mark.gif','danger.gif','ban.gif','empty.gif','pass.gif','full.gif','leftright.gif','updown.gif','school.gif','wave.gif','fuji.gif','clover.gif','cherry.gif','tulip.gif','banana.gif','apple.gif','bud.gif','maple.gif','cherryblossom.gif','riceball.gif','cake.gif','bottle.gif','noodle.gif','bread.gif','snail.gif','chick.gif','penguin.gif','fish.gif','delicious.gif','smile.gif','horse.gif','pig.gif','wine.gif','shock.gif'];
CKEDITOR.config.mobilepictogram_descriptions=['sun','cloud','rain','snow','thunder','typhoon','mist','sprinkle','aries','taurus','gemini','cancer','leo','virgo','libra','scorpius','sagittarius','capricornus','aquarius','pisces','sports','baseball','golf','tennis','soccer','ski','basketball','motorsports','pocketbell','train','subway','bullettrain','car','rvcar','bus','ship','airplane','house','building','postoffice','hospital','bank','atm','hotel','24hours','gasstation','parking','signaler','toilet','restaurant','cafe','bar','beer','fastfood','boutique','hairsalon','karaoke','movie','upwardright','carouselpony','music','art','drama','event','ticket','smoking','nosmoking','camera','bag','book','ribbon','present','birthday','telephone','mobilephone','memo','tv','game','cd','heart','spade','diamond','club','eye','ear','rock','scissors','paper','downwardright','upwardleft','foot','shoe','eyeglass','wheelchair','newmoon','moon1','moon2','moon3','fullmoon','dog','cat','yacht','xmas','downwardleft','phoneto','mailto','faxto','info01','info02','mail','by-d','d-point','yen','free','id','key','enter','clear','search','new','flag','freedial','sharp','mobaq','one','two','three','four','five','six','seven','eight','nine','zero','ok','heart01','heart02','heart03','heart04','happy01','angry','despair','sad','wobbly','up','note','spa','cute','kissmark','shine','flair','annoy','punch','bomb','notes','down','sleepy','sign01','sign02','sign03','impact','sweat01','sweat02','dash','sign04','sign05','slate','pouch','pen','shadow','chair','night','soon','on','end','clock','appli01','appli02','t-shirt','moneybag','rouge','denim','snowboard','bell','door','dollar','pc','loveletter','wrench','pencil','crown','ring','sandclock','bicycle','japanesetea','watch','think','confident','coldsweats01','coldsweats02','pout','gawk','lovely','good','bleah','wink','happy02','bearing','catface','crying','weep','ng','clip','copyright','tm','run','secret','recycle','r-mark','danger','ban','empty','pass','full','leftright','updown','school','wave','fuji','clover','cherry','tulip','banana','apple','bud','maple','cherryblossom','riceball','cake','bottle','noodle','bread','snail','chick','penguin','fish','delicious','smile','horse','pig','wine','shock'];
