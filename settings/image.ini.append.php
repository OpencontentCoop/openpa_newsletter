<?php /* 

[ImageMagick]
Filters[]=thumb=-resize 'x%1' -resize '%1x<' -resize 50%
Filters[]=centerimg=-gravity center -crop %1x%2+0+0 +repage
#Filters[]=play_watermark=extension/opencontent/design/standard/images/i-play-2.png -composite -gravity Center
#Filters[]=play_watermark_big=extension/opencontent/design/ftcoop_base/images/icons/play-btn.png -composite -gravity Center


[AliasSettings]
AliasList[]=newsletter_video
AliasList[]=newsletter_default
AliasList[]=newsletter_focus


[newsletter_default]
Reference=
Filters[]
Filters[]=geometry/scalewidthdownonly=124

[newsletter_focus]
Reference=
Filters[]
Filters[]=geometry/scalewidthdownonly=180
Filters[]=geometry/crop=200;200;0;0

[newsletter_video]
Reference=
Filters[]
Filters[]=geometry/scalewidthdownonly=200
Filters[]=centerimg=200;150
#Filters[]=play_watermark





*/ ?>
