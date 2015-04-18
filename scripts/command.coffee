require('date-utils');

getTimeDiffAsMinutes = (old_msec) ->
  now = new Date()
  old = new Date(old_msec)
  diff_msec = now.getTime() - old.getTime()
  diff_minutes = parseInt( diff_msec / (60*1000), 10 )
  return diff_minutes

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

  robot.respond /(\S+)/i, (msg) ->
    DOCOMO_API_KEY = process.env.DOCOMO_API_KEY
    message = msg.match[1]
    return unless DOCOMO_API_KEY && message

    ## ContextIDを読み込む
    KEY_DOCOMO_CONTEXT = 'docomo-talk-context'
    context = robot.brain.get KEY_DOCOMO_CONTEXT || ''

    ## mode読み込む。前回しりとりだったらしりとりにする
    KEY_DOCOMO_MODE = 'docomo-talk-mode'
    mode = robot.brain.get KEY_DOCOMO_MODE || ''

    ## 前回会話してからの経過時間調べる
    KEY_DOCOMO_CONTEXT_TTL = 'docomo-talk-context-ttl'
    TTL_MINUTES = 20
    old_msec = robot.brain.get KEY_DOCOMO_CONTEXT_TTL
    diff_minutes = getTimeDiffAsMinutes old_msec

    ## 前回会話してから一定時間経っていたらコンテキストを破棄
    if diff_minutes > TTL_MINUTES
      context = ''

    url = 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue?APIKEY=' + DOCOMO_API_KEY
    user_name = msg.message.user.name

    request = require('request');
    request.post
      url: url
      json:
        utt: message
        nickname: user_name if user_name
        context: context if context
        mode: mode if mode
        t: 30
      , (err, response, body) ->
        ## ContextIDの保存
        robot.brain.set KEY_DOCOMO_CONTEXT, body.context

        ## modeの保存
        robot.brain.set KEY_DOCOMO_MODE, body.mode

        ## 会話発生時間の保存
        now_msec = new Date().getTime()
        robot.brain.set KEY_DOCOMO_CONTEXT_TTL, now_msec

        msg.send body.utt
