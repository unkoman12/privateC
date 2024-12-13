gg.alert("たぬきうどんは首吊って死ね")

function Main()
    local options = {
        {"重力系メニュー", gravity},
        {"座標系メニュー", Current},
        {"人物系メニュー", movement},
        {"武器系メニュー", weapons},
        {"究極の超サイヤ人オマンクス！！！！", omankusu},
        {"武器Patch", WeaponPatch},
        {"宝箱系メニュー", ChestMenu},
        {"よころわメニュー", yokorowa},
        {"うんこ１", unko},
        {"終了", os.exit},
    }
    
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    
    local Menu = gg.choice(labels, nil, 'しねやpolar')
    if Menu == nil then 
        YUNI = 0
        return
    end
    
    options[Menu][2]()
    YUNI = 1
end

function gravity()
    local gravityLabel = iszerogravity() and "無重力 [ON]" or "無重力 [OFF]"
    local options = {
        {gravityLabel, iszerogravity}
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end
    YUNI = -1
end

function iszerogravity()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("BA921000h", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
    local results = gg.getResults(1000)
    if #results > 0 then
        gg.editAll("C1E00000h", gg.TYPE_QWORD)
        gg.toast("無重力 OFF")
        return false
    else
        gg.clearResults()
        gg.searchNumber("C1E00000h", gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        results = gg.getResults(1000)
        if #results > 0 then
            gg.editAll("BA921000h", gg.TYPE_QWORD)
            gg.toast("無重力 ON")
            return true
        else
            gg.toast("検索結果が見つかりませんでした")
            return false
        end
    end
    gg.clearResults()
end


--座標系メニュー
function Current()
    local options = {
        {"現在の座標を表示", NowON},
        {"白チームの前にTP", whitebaseTP},
        {"赤チームの前にTP", redbaseTP},
        {"カスタムテレポート", customTP},
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end
    YUNI = -2
end
function searchCoordinates()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("17170436", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    return gg.getResults(gg.getResultCount())
end

function setCoordinates(results, x, y, z)
    if #results > 0 then
        local a = {}
        local n = 1
        for i = 1, #results do
            a[n] = { address = results[i].address - 12, flags = gg.TYPE_FLOAT, value = x }
            n = n + 1
            a[n] = { address = results[i].address - 8, flags = gg.TYPE_FLOAT, value = y }
            n = n + 1
            a[n] = { address = results[i].address - 4, flags = gg.TYPE_FLOAT, value = z }
            n = n + 1
        end
        gg.setValues(a)
        gg.toast("座標移動成功")
    else
        gg.toast("検索結果が見つかりませんでした")
    end
end

function NowON()
    local results = searchCoordinates()
    if #results > 0 then
        local lastResult = results[#results]
        local a = {
            { address = lastResult.address - 12, flags = gg.TYPE_FLOAT },
            { address = lastResult.address - 8, flags = gg.TYPE_FLOAT },
            { address = lastResult.address - 4, flags = gg.TYPE_FLOAT }
        }
        local values = gg.getValues(a)
        local message = string.format("最後の結果の座標:\nX: %d\nY: %d\nZ: %d", math.floor(values[1].value), math.floor(values[2].value), math.floor(values[3].value))
        gg.alert(message)
    else
        gg.toast("検索結果が見つかりませんでした")
    end
end

function whitebaseTP()
    setCoordinates(searchCoordinates(), 127.361992, 1.21, -119.180000)
end

function redbaseTP()
    setCoordinates(searchCoordinates(), -127.361992, 1.21, -119.180000)
end

function customTP()
    local results = searchCoordinates()
    if #results > 0 then
        local input = gg.prompt(
            {
                "X座標を入力してください（例: 6）",
                "Y座標を入力してください（例: 99）",
                "Z座標を入力してください（例: 6）"
            },
            {0, 0, 0},
            {"number", "number", "number"}
        )
        if input then
            setCoordinates(results, input[1], input[2], input[3])
        else
            gg.toast("座標が入力されませんでした")
        end
    else
        gg.toast("検索結果が見つかりませんでした")
    end
end
--人物系メニュー
function movement()
    local options = {
        {"ハイジャンプ", HighJump},
        {"ハイスピード 中", Highspeed},
        {"ハイスピード 低", lowspeed},
        {"無限ジャンプ", airjump},
        {"水ジャンプ", waterjump},
        {"バトロワ無敵", muteki},
        {"ヨコロワ無敵", yokorowamuteki},
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end

    YUNI = -2
end

function HighJump() --ハイジャンプ
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("2047615188", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1)
    local revert = gg.getResults(100)
    gg.editAll("2048120059", gg.TYPE_DWORD)
    gg.processResume()
    gg.toast("ハイジャンプON")
    gg.clearResults()
end
function Highspeed() --ハイスピード
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("6.874417363427344e+28", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
    local revert = gg.getResults(100)
    if revert then
        gg.editAll("8.0000002e26", gg.TYPE_FLOAT)
        gg.toast("ハイスピードON")
    else
        gg.toast("検索結果が見つかりませんでした")
    end
    gg.clearResults()
end
function lowspeed() --ハイスピード
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("6.874417363427344e+28", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1, 0)
    local revert = gg.getResults(100)
    if revert then
        gg.editAll("98744175632069373439625920512", gg.TYPE_FLOAT)
        gg.toast("ハイスピードON")
    else
        gg.toast("検索結果が見つかりませんでした")
    end
    gg.clearResults()
end
function airjump() --無限ジャンプ
    gg.clearResults()
    gg.setRanges(gg.REGION_C_DATA)
    gg.searchNumber("h9A99993E", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    
    local revert = gg.getResults(100)
    
    if #revert > 0 then
        gg.editAll("h003C1C46003C1C46", gg.TYPE_BYTE)
        gg.processResume()
        gg.toast("無限ジャンプON")
    else
        gg.toast("検索結果が見つかりませんでした")
    end
    
    gg.clearResults()
end
function waterjump() --水ジャンプ
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("1,121,193,960", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1000)
    local a = {}
    local n = 1
    
    for i = 1, #r do
      a[n] = {}
      a[n].address = r[i].address - 0xA8
      a[n].flags = gg.TYPE_DWORD
      a[n].value = 1
      n = n + 1
    end 
    gg.setValues(a)
  end

  
function muteki() --無敵（バトロワなど）
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("h6400000001010000", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber("100", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1000)

    if r then
        local a = {}
        local n = 1
        for i = 1, #r do
            a[n] = { address = r[i].address - 0x8, flags = gg.TYPE_DWORD, value = 99999 }
            n = n + 1
        end 
        gg.toast("無敵ON")
        gg.setValues(a)
    else
        gg.toast("検索結果が見つかりませんでした")
    end
end
function yokorowamuteki() --よころわむてき
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("h5802000001010000", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.refineNumber("600", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1000)
    local a = {}
    local n = 1

    for i = 1, #r do
        a[n] = {
            address = r[i].address - 0x8,
            flags = gg.TYPE_DWORD,
            value = 999999,
            freeze = true
        }
        n = n + 1
    end
    gg.setValues(a)
    gg.addListItems(a)
    gg.toast("ヨコロワ無敵 ON")
end

--武器系メニュー

function weapons()
    local options = {
        {"武器連射＋反映", hanei},
        {"武器改造 OFF", modweaponOFF},
        {"武器改造 ちょこぷりとか", weaponV2},
        {"武器改造 瓶のやつとか", weaponV1},
        {"武器改造 1", modweaponON},
        {"武器改造 2", modweapon2ON},
        {"武器改造 3", modweapon3ON},
        {"武器改造 4", modweapon4ON},
        {"武器改造 5", modweapon5ON},
        {"武器連射 通常モード", rapitfireNomal},
        {"SPAIサポートモード", rapitfirespai},
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end

    YUNI = -2
end

function omankusu()
    local options = {
        {"武器連射＋反映", hanei},
        {"武器改造 OFF", modweaponOFF},
        {"武器改造 オマンクス！！", gunV1},
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end

    YUNI = -2
end

function gunV1()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "7,123,622,064,335,627,029"}, --岩みたいなの投げるやつ
        {search = "8,714,128,229,137,304,946", edit = "8,713,584,705,320,835,868"}, --るかがーるSAI
        {search = "4,348,150,287,900,851,118", edit = "7,585,539,973,152,331,043"}, --瓶入手
        {search = "4,779,651,813,845,810,188", edit = "7,520,151,750,345,287,529"}, --くっきー撃つかすぴちの銃
        {search = "6,830,252,227,170,004,540", edit = "8356735350289798804"}, --旧看守棒
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end

function weaponV1()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "5957472807509898776"}, --瓶 普通
        {search = "8,714,128,229,137,304,946", edit = "7072042234402891557"}, --はろめい
        {search = "4,348,150,287,900,851,118", edit = "7594854902521026534"}, --TP
        {search = "4,779,651,813,845,810,188", edit = "5957472820394800664"}, --瓶 むらさきのやつ
        {search = "6,830,252,227,170,004,540", edit = "5,867,736,346,376,698,970"}, --グリーン
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end

function weaponV2()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "6449336147444281397"}, --範囲内の味方を復活させる
        {search = "8,714,128,229,137,304,946", edit = "8164418693393929328"}, --無敵貫通火の玉
        {search = "4,348,150,287,900,851,118", edit = "5,004,125,161,477,251,134"}, --拘束槍
        {search = "4,779,651,813,845,810,188", edit = "7562982822088346034"}, --無敵貫通火の玉
        {search = "6,830,252,227,170,004,540", edit = "8356735350289798804"}, --看守棒
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end

function modweaponON()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "7,928,489,937,836,941,428"},--黒い剣
        {search = "8,714,128,229,137,304,946", edit = "4,459,975,521,029,393,313"},--UFO
        {search = "4,348,150,287,900,851,118", edit = "7176040636956964274"},--炎の剣
        {search = "4,779,651,813,845,810,188", edit = "5,490,264,667,214,402,069"},--SPAIのクールタイムを徐々に減少させる
        {search = "6,830,252,227,170,004,540", edit = "5298446192165247164"},--貫通銃
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end

function modweapon2ON()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "7594854902521026534"},--敵を吸い込む銃 --7594854902521026534
        {search = "8,714,128,229,137,304,946", edit = "7,014,110,306,751,690,576"},--TP
        {search = "4,348,150,287,900,851,118", edit = "9154010361560142857"},--卵
        {search = "4,779,651,813,845,810,188", edit = "4341835367419304782"},--流星群
        {search = "6,830,252,227,170,004,540", edit = "5874208436891509112"},--大砲
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end

function modweapon3ON()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "6,792,867,371,528,032,116"},--シャボン銃 => ヴぁるつ
        {search = "8,714,128,229,137,304,946", edit = "6,792,867,371,528,032,116"},--通常テレポート => ぁるつ
        {search = "4,348,150,287,900,851,118", edit = "6,501,296,301,026,126,813"},--インパルス => かみなり
        {search = "4,779,651,813,845,810,188", edit = "6,501,296,301,026,126,813"},--火炎銃 => かみなり
        {search = "6,830,252,227,170,004,540", edit = "6,501,296,301,026,126,813"},--リモボ => かみなり
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end

function modweapon4ON()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "7160116981278821677"},--シャボン銃 => 雷
        {search = "8,714,128,229,137,304,946", edit = "7594854902521026534"},--通常テレポート => 目玉焼き落とす
        {search = "4,348,150,287,900,851,118", edit = "5874208436891509112"},--インパルス => 目玉焼き
        {search = "4,779,651,813,845,810,188", edit = "4341835367419304782"},--火炎銃 => 瓶
        {search = "6,830,252,227,170,004,540", edit = "9021198316195654500"},--リモボ => 黒い剣
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end


function modweapon5ON()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = "8356735350289798804"},--シャボン銃 => 看守ゆきゅう
        {search = "8,714,128,229,137,304,946", edit = "8356735350289798804"},--通常テレポート => 看守ゆきゅう
        {search = "4,348,150,287,900,851,118", edit = "9,139,078,607,104,414,368"},--インパルス => とうめいか
        {search = "4,779,651,813,845,810,188", edit = "5874208436891509112"},--火炎銃 => たいほう
        {search = "6,830,252,227,170,004,540", edit = "5874208436891509112"},--リモボ => たいほう
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        if #r > 0 then
            local a = {}
            for j = 1, #r do
                a[j] = {}
                a[j].address = r[j].address + 0x10
                a[j].flags = gg.TYPE_QWORD
                a[j].value = v.edit
            end
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end



function modweaponOFF()
    local searches = {
        {search = "7,037,678,785,175,149,466", edit = 4788831073787533424},
        {search = "8,714,128,229,137,304,946", edit = 8754357937972820513},
        {search = "4,348,150,287,900,851,118", edit = 4720532735758873481},
        {search = "4,779,651,813,845,810,188", edit = 4644890888415606697},
        {search = "6,830,252,227,170,004,540", edit = 7358743112637710803},
    }
    local successCount = 0
    for i, v in ipairs(searches) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(v.search, gg.TYPE_QWORD, false, gg.SIGN_EQUAL, 0, -1)
        local r = gg.getResults(1000)
        local a = {}
        for j = 1, #r do
            a[j] = {}
            a[j].address = r[j].address + 0x10
            a[j].flags = gg.TYPE_QWORD
            a[j].value = v.edit
        end
        if #a > 0 then
            gg.setValues(a)
            successCount = successCount + 1
        end
        if i % 5 == 0 then
            gg.toast("処理中... " .. i .. "個目の項目を変更中")
        end
    end
    gg.clearResults()
    gg.toast("変更を完了しました: " .. successCount .. "件")
end


function rapitfireNomal()
    local patterns = {
        "h10 AA 6E 67", "h65 88 73 6E", "h25 90 0D 6A", "h62 B9 C3 4A",
        "hDD 65 9A 4B", "h9F 1E 21 66", "hD8 F5 44 60", "hA4 CF FE 78",
        "h69 F8 04 58", "h3E AC B6 54", "h2C 3F 0B 63", "h50 6B E7 40"
    }
    local offsets = {-0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24}
    for _, pattern in ipairs(patterns) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(pattern, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        local results = gg.getResults(1000)
        local addresses = {}
        for _, result in ipairs(results) do
            for _, offset in ipairs(offsets) do  
                table.insert(addresses, { address = result.address + offset, flags = gg.TYPE_DWORD, value = 0 })
            end
        end

        gg.setValues(addresses)
    end
end

function rapitfirespai()
    local patterns = {
        "h7E 93 93 6B", "hAE FF 78 3D", "h25 90 0D 6A", "hA4 CF FE 78",
        "h2C 3F 0B 63", "h69 F8 04 58", "1,515,282,994", "1,165,510,785", "h45 78 48 81"
    }

    local offsets = {-20, -16, 32, 36}
    local specialOffsets = {-10, 10, -24}
    for _, pattern in ipairs(patterns) do
        gg.clearResults()
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.searchNumber(pattern, gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
        local results = gg.getResults(1000)
        local addresses = {}
        for _, result in ipairs(results) do
            for _, offset in ipairs(offsets) do
                table.insert(addresses, { address = result.address + offset, flags = gg.TYPE_DWORD, value = 0 })
            end
            if pattern == "1,165,510,785" then
                for _, offset in ipairs(specialOffsets) do
                    table.insert(addresses, { address = result.address + offset, flags = gg.TYPE_DWORD, value = 0 })
                end
            end
        end

        gg.setValues(addresses)
    end
end

function hanei()
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    local searchValues = {
        { "1735305744", { -0x44, -0x88, -0xA0, -0x14, -0x10, 0x10, 0x20, 0x24 }, "パンチ" },
        { "1031339950", { -0x44, -0x88, -0xA0, -0x14, -0x10, 0x10, 0x20, 0x24 }, "SAI入手器" },
        { "1476720745", { -0x44, -0x84, -0xA0, -0x14, -0x10, 0x10, 0x20, 0x24 }, "AIワープ" },
        { "1165510785", { -0x44, -0x84, -0xA0, -0x14, -0x10, 0x10, 0x20, 0x24 }, "瓶" },
        { "1088908112", { -0x44, -0x88, -0xA0, -0x14, -0x10, 0x10, 0x20, 0x24 }, "大砲" },
        { "1853065317", { -0x44, -0x84, -0xA0, -0x14, -0x10, 0x10, 0x20, 0x24 }, "グレネード系" },
        { "1254340962", { -0x44, -0x14, -0x10, 0x10, 0x20, 0x24 }, "人狼棒、看守武器" },
        { "1515282994", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "流星群" },
        { "1268409821", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "足止め" },
        { "1779273765", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "フジフジ拘束" },
        { "1713446559", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "水鉄砲系" },
        { "2029965220", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "インパルス" },
        { "1615132120", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "水風船" },
        { "1661681452", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "りもぼ" },
        { "1804833662", { -0x44, -0x80, -0x84, -0x14, -0x10, 0x10, 0x20, 0x24 }, "なにかしらんやつ" }
    }
    local successCount = 0
    for index, searchInfo in ipairs(searchValues) do
        local numberToSearch = searchInfo[1]
        local offsets = searchInfo[2]
        local itemName = searchInfo[3]
        gg.searchNumber(numberToSearch, gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
        local results = gg.getResults(1000)
        local setValues = {}
        for _, r in ipairs(results) do
            for _, offset in ipairs(offsets) do
                table.insert(setValues, { address = r.address + offset, flags = gg.TYPE_DWORD, value = 0 })
            end
        end
        if #setValues > 0 then
            gg.setValues(setValues)
            successCount = successCount + 1
        end
        gg.clearResults()
        if index % 5 == 0 then
            gg.toast("処理中... " .. index .. "個目のアイテムを処理中")
        end
    end
    gg.toast("変更または連射可能にした項目: " .. successCount .. "件")
end


--武器Patch
function WeaponPatch()
    local options = {
        {"グリーン拘束 無効", GreenDisable},
        {"拘束槍 無効", RestraintSpearDisable},
        {"トラップ無効", TrapDisable},
        {"バリア 無効", BarrierDisable},
        {"AIテレポート 無効", AIteleportDisable},
        {"ヴァルツSAI 無効", VartuDisable},
        {"階段 無効化", kaidanDisable},
        {"岩 無効化", iwaDisable},
        {"噴水 無効化", hunsuiDisable},
        {"回復リモートボム 無効化", kaihukurimoboDisable},
        {"雷 無効化", kaminariDisable},
        {"威力5/10/30の連続攻撃 無効化", renzokuDisable},
        {"威力15の爆発弾+2個のアイテム入手 無効化", bakuhatudanDisable},
        {"隕石 無効化", InsekiDisableDisable},
        {"炎の剣 無効化", FireSwordDisable},
        {"プレゼントボックス 無効化", boxdisable},
        {"周囲ダメージ 無効化", RangeDamageDisable},
        {"吸血鬼みたいなやつ 無効化", dizh2},
        {"PunchESP", punchESP},
        {"連続格闘攻撃 無効化", continuousAttack},
        {"黒い剣 無効化", BlackSworddisable},
        {"UFO 無効化", UFOdisable},
        {"クールタイム減少 無効化", cooltimeDisable},
        {"ピッケル 無効化", iceaxdisable},
        {"花 無効化", flourdisable},
        {"鳥居 無効化", toriidisable},
        {"大砲 無効化", taihoudisable},
        {"青いキャラの噴水 無効化", hunsuiDisable},
        {"パンチアイス", punchrecovery},
        {"卵無効", eggdisable},
        {"目玉焼き入手 無効", medamayakiDisable},
        {"アニメーション無効", opt},
        {"変身 無効", hensindisable},
        {"透明化 無効", toumeikadisable},
        {"流星群 無効", ryuseigunDisable},
        {"判定無効軽量化", hanteimukouDisable},

    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end
    YUNI = -2
end

local GreenValue = 7594854902521026534 --グリーン
local RestraintSpearValue = 9021198316195654500 --拘束槍
local TrapValue = 8195448612344042769 --トラップ
local BarrireValue = 5839750236390219943 --バリア
local teleportValue = 5867736346376698970 --teleport
local VartuValue = 6792867371528032116 --ヴァルつ
local kaidanValue = 8447707215816312647 --階段
local iwaValue = 8501659439655023370 --岩
local hunsuiValue = 4688285189285095325 --噴水
local kaihukurimoboValue = 8476157457148762367 --回復リモートボム
local kaminariValue = 6501296301026126813 --雷
local renzoku5Value = 7176031639000479154 --連続攻撃の剣
local bakuhatudanValue = 5004125161477251134 --爆発弾+二個の武器を入手
local insekiValue = 9163269138526399660 --隕石
local FireSwordValue = 7176040636956964274 --炎の剣
local PresentBoxValue = 5033834146055307941 --プレゼントボックス
local RangeDamageValue = 4342666112878783105 --周囲ダメージ
local ondahive = 4792544755915593040 ---dwdw
local punchValue = 7566421188222735354 ---dwdw
local continuousAtt = 7116024443280897377 --連続格闘攻撃（えと）
local BlackSword = 7928489937836941428 --黒い剣
local UFOvalue = 4459975521029393313 --UFO
local CooltimeSAIValue = 5490264667214402069 --くーるたいむげんしょう
local iceaxvalue = 8285259226087633433 --ピッケル
local flowervalue = 8637746724000986503 --花
local toriivalue = 4455778779634469967 --鳥居

--ちなみにリゼルはからぴちで抜いてる
function GreenDisable() -- グリーン
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(GreenValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function RestraintSpearDisable() --拘束槍
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(RestraintSpearValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function TrapDisable() --トラップ
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("6501296301026126813", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(TrapValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function BarrierDisable() --バリア
        gg.setRanges(gg.REGION_ANONYMOUS)
        gg.clearResults()
        gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
        local res = gg.getResults(1)
        if #res == 0 then return gg.alert("value not found") end
        
        local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
        gg.clearResults()
        gg.searchNumber(BarrireValue, gg.TYPE_QWORD)
        local weapons = gg.getResults(100)
        if #weapons == 0 then return gg.alert("value not found") end
        for _, w in ipairs(weapons) do 
            w.address = w.address + 0x70 
            w.value = val 
        end
        gg.setValues(weapons)
end

function AIteleportDisable()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(teleportValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function VartuDisable() --ヴァルツSAI
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(VartuValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function kaidanDisable() --階段
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(kaidanValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function iwaDisable() --岩
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(iwaValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function hunsuiDisable() --噴水
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(hunsuiValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function kaihukurimoboDisable() --回復リモートボム
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(kaihukurimoboValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function kaminariDisable() --雷
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(kaminariValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function renzokuDisable() --威力5/10/30の連続攻撃
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(renzoku5value, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function bakuhatudanDisable() --威力15の爆発弾+2個のアイテム入手
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(bakuhatudanValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function InsekiDisable() --威力30の隕石軽量化
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(insekiValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function FireSwordDisable() --炎の剣
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(FireSwordValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function boxdisable() --プレゼントボックス
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(PresentBoxValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function RangeDamageDisable() --周囲ダメージ
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(RangeDamageValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function dizh2() --testmodule
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(ondahive, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function punchESP() --testmodule
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("h2DCD5D63 75D85D63", gg.TYPE_BYTE)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("7566421188222735354", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function continuousAttack() --testmodule
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(continuousAtt, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function BlackSworddisable() --testmodule
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(BlackSword, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function cooltimeDisable() --testmodule
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(CooltimeSAIValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function UFOdisable() --testmodule
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(UFOvalue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function iceaxdisable() --ぴっける
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(iceaxvalue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function flourdisable() --花
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(flowervalue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function toriidisable() --ぴっける
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(toriivalue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

--5874208436891509112

function taihoudisable() --大砲
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("6558252613970925570", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("5874208436891509112", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

--8,285,259,226,087,633,433

function humsuudisable() --大砲
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("7,918,688,332,838,914,646", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function punchrecovery() --パンチアイス
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7118627438276014591", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

--9154010361560142857卵無効
function eggdisable() --パンチアイス
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7118627438276014591", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("9154010361560142857", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

--4,368,176,234,348,077,357変身

function hensindisable() --変身
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("7118627438276014591", gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("4,368,176,234,348,077,357", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end


function toumeikadisable() --透明化
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("9,139,078,607,104,414,368", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

--4,510,184,599,264,391,609

function medamayakiDisable() --パンチアイス
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("4,510,184,599,264,391,609", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function ryuseigunDisable() --パンチアイス
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("4341835367419304782", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

--7160116981278821677

function hanteimukouDisable() --パンチアイス
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber(punchValue, gg.TYPE_QWORD)
    local res = gg.getResults(1)
    if #res == 0 then return gg.alert("value not found") end
    
    local val = gg.getValues({{address = res[1].address + 0x70, flags = gg.TYPE_QWORD}})[1].value
    gg.clearResults()
    gg.searchNumber("7160116981278821677", gg.TYPE_QWORD)
    local weapons = gg.getResults(100)
    if #weapons == 0 then return gg.alert("value not found") end
    for _, w in ipairs(weapons) do 
        w.address = w.address + 0x70 
        w.value = val 
    end
    gg.setValues(weapons)
end

function ChestMenu()
    local options = {
        {"無限宝箱", INFchestmenu},
        {"a", ChestMenu0},
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end

    YUNI = -2
end

function INFchestmenu()
    gg.clearResults()
    gg.searchNumber("hA086294D A009860D", gg.TYPE_BYTE)
    gg.refineNumber("-96", gg.TYPE_BYTE)
    local r = gg.getResults(4000)
    local dizh1 = {}
    local dizh2 = 1
    for i = 1, #r do
        dizh1[dizh2] = {}
        dizh1[dizh2].address = r[i].address + 0x20
        dizh1[dizh2].flags = gg.TYPE_FLOAT
        dizh1[dizh2].value = 1
        dizh2 = dizh2 + 1
    end
    gg.setValues(dizh1)
end

function ChestMenu0()
    gg.clearResults()
    gg.searchNumber("h9F89BF5E 9F9F891E", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    gg.searchNumber("-97", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    local r = gg.getResults(1000)
    local dizh1 = {}
    local dizh2 = 1
    for i = 1, #r do
      dizh1[dizh2] = {}
      dizh1[dizh2].address = r[i].address + 0x78
      dizh1[dizh2].flags = gg.TYPE_DWORD
      dizh1[dizh2].value = 1
      dizh2 = dizh2 + 4
      i = i + 1
    end 
    gg.setValues(dizh1)
end  

function opt()
    gg.clearResults()
    gg.searchNumber("h0000803FABAAAA3E8FC2F53C", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)
    revert = gg.getResults(100, nil, nil, nil, nil, nil, nil, nil, nil)
    gg.editAll("h0000803FABAAAA3E00000000", gg.TYPE_BYTE)
    gg.processResume()
    gg.toast("軽量化成功")
    gg.clearResults()
    end

--        gg.refineNumber("-96", gg.TYPE_BYTE, false, gg.SIGN_EQUAL, 0, -1, 0)


function yokorowa()
    local options = {
        {"Y固定 ON", YkoteiOff},
        {"Y固定 OFF", YkoteiOff},
        {"X固定 ON", XkoteiOn},
        {"X固定 OFF", XkoteiOff},
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end

    YUNI = -2
end


local freeze_list_x = {}
local freeze_list_y = {}

function YkoteiOn()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("17170436", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    local results = gg.getResults(gg.getResultCount())

    if #results > 0 then
        freeze_list_y = {}
        for i = 1, #results do
            freeze_list_y[i] = {
                address = results[i].address - 8, 
                flags = gg.TYPE_FLOAT,
                value = 20,
                freeze = true
            }
        end
        gg.setValues(freeze_list_y)
        gg.addListItems(freeze_list_y)
        gg.toast("Y座標フリーズ ON")
    else
        gg.toast("検索結果が見つかりませんでした")
    end
end

function YkoteiOff()
    if #freeze_list_y > 0 then
        gg.removeListItems(freeze_list_y)
        gg.toast("Y座標フリーズ OFF")
    else
        gg.toast("フリーズする項目が見つかりません")
    end
end





function XkoteiOn()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.clearResults()
    gg.searchNumber("17170436", gg.TYPE_DWORD, false, gg.SIGN_EQUAL, 0, -1, 0)
    local results = gg.getResults(gg.getResultCount())

    if #results > 0 then
        freeze_list_x = {}
        for i = 1, #results do
            freeze_list_x[i] = {
                address = results[i].address - 12,
                flags = gg.TYPE_FLOAT,
                value = 0,
                freeze = true
            }
        end
        gg.setValues(freeze_list_x)
        gg.addListItems(freeze_list_x)
        gg.toast("X座標フリーズ ON")
    else
        gg.toast("検索結果が見つかりませんでした")
    end
end

function XkoteiOff()
    if #freeze_list_x > 0 then
        gg.removeListItems(freeze_list_x)
        gg.toast("X座標フリーズ OFF")
    else
        gg.toast("フリーズする項目が見つかりません")
    end
end


function unko()
    local options = {
        {"視野角変更 ON", FOVdistance},
        {"視野角変更 OFF", FOVdistanceOff},
    }
    local labels = {}
    for i = 1, #options do
        labels[i] = options[i][1]
    end
    local siubo = gg.multiChoice(labels, nil, 'PlayinEscapePro')
    if siubo == nil then return end
    for i = 1, #options do
        if siubo[i] then
            options[i][2]()
        end
    end

    YUNI = -2
end


function FOVdistance()
    local previousItems = gg.getListItems()
    if #previousItems > 0 then
        gg.removeListItems(previousItems)
        gg.toast("以前のフリーズリストを削除しました")
    end
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS)
    gg.searchNumber("-6.50;3.0", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    gg.refineNumber("-6.50", gg.TYPE_FLOAT, false, gg.SIGN_EQUAL, 0, -1)
    local a = gg.getResults(5)
    if #a > 0 then
        for i, v in ipairs(a) do
            v.value = "-15"
            v.freeze = true
        end
        gg.setValues(a)
        gg.addListItems(a)
        gg.toast("視野角が変更・固定されました")
    else
        gg.toast("検索結果が見つかりませんでした")
    end
end

function FOVdistanceOff()
    local previousItems = gg.getListItems()
    if #previousItems > 0 then
        gg.removeListItems(previousItems)
        gg.toast("視野角の固定を解除しました")
    else
        gg.toast("解除するフリーズリストはありません")
    end
end

    while true do
    if gg.isVisible(true) then
        YUNI = 1
        gg.setVisible(false)
    end
    if YUNI == 1 then
        Main()
    end
end
