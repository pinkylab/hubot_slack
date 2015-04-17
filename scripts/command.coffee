require('date-utils');

module.exports = (robot) ->
  robot.hear /ぬるぽ/, (msg) ->
    msg.send '''

   Λ＿Λ    ＼＼
  （ ・∀・）   | | ｶﾞｯ
 と       ）   | |
   Ｙ /ノ     人
    / ）     <  >  _Λ∩
 ＿/し' ／／  Ｖ｀Д´）/
 （＿フ彡            / ←>>1
'''

  robot.respond /.*出社.*/, (res) ->
    res.send "おはようございます:heart:"

  robot.respond /.*帰.*/, (res) ->
    res.send "さようなら:heart:"

  robot.hear /.*ゆかりん.*/, (msg) ->
    msg.send "なぁに？"

  robot.hear /時間/i, (msg) ->
    dt = new Date();
    formatted = dt.toFormat("HH24MI");
    img_url = 'http://www.bijint.com/jp/tokei_images/TIME.jpg'.replace('TIME', formatted)
    msg.send(img_url)
