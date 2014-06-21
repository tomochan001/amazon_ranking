#!/usr/bin/ruby
# coding: utf-8

# カニバリズム実態調査
# ver.1 (2014/6/15)
# amaran（http://www.rankbank.net/amaran/rank/）のランキング情報を使って、紙と電子本のベストセラーがどれだけ重複しているかを調査する
# メモ。URLは以下のようになる。
# http://www.rankbank.net/amaran/rank/?date=14020100&cat=book&page=0
# ページは0が1〜100位まで、1が101〜200位まで、2が201位〜300位まで
# dateはYYMMDDTT。今回、TTは固定にする（00）。
# とりあえず、2012年11月1日から2014年5月30日まで

require "rubygems"
require "nokogiri"
require "open-uri"
require "cgi"

# 変数
base_url = "http://www.rankbank.net/amaran/rank/" 

target_date = []

# year2012
target_date = %w!12110101 12110201 12110301 12110401 12110501 12110601 12110701 12110801 12110901 12111001 12111101 12111201 12111301 12111401 12111501 12111601 12111701 12111801 12111901 12112001 12112101 12112201 12112301 12112401 12112501 12112601 12112701 12112801 12112901 12113001 12120101 12120201 12120301 12120401 12120501 12120601 12120701 12120801 12120901 12121001 12121101 12121201 12121301 12121401 12121501 12121601 12121701 12121801 12121901 12122001 12122101 12122201 12122301 12122401 12122501 12122601 12122701 12122801 12122901 12123001 12123101 13010101 13010201 13010301 13010401 13010501 13010601 13010701 13010801 13010901 13011001 13011101 13011201 13011301 13011401 13011501 13011601 13011701 13011801 13011901 13012001 13012101 13012201 13012301 13012401 13012501 13012601 13012701 13012801 13012901 13013001 13013101 13020101 13020201 13020301 13020401 13020501 13020601 13020701 13020801 13020901 13021001 13021101 13021201 13021301 13021401 13021501 13021601 13021701 13021801 13021901 13022001 13022101 13022201 13022301 13022401 13022501 13022601 13022701 13022801 13030101 13030201 13030301 13030401 13030501 13030601 13030701 13030801 13030901 13031001 13031101 13031201 13031301 13031401 13031501 13031601 13031701 13031801 13031901 13032001 13032101 13032201 13032301 13032401 13032501 13032601 13032701 13032801 13032901 13033001 13033101 13040101 13040201 13040301 13040401 13040501 13040601 13040701 13040801 13040901 13041001 13041101 13041201 13041301 13041401 13041501 13041601 13041701 13041801 13041901 13042001 13042101 13042201 13042301 13042401 13042501 13042601 13042701 13042801 13042901 13043001 13050101 13050201 13050301 13050401 13050501 13050601 13050701 13050801 13050901 13051001 13051101 13051201 13051301 13051401 13051501 13051601 13051701 13051801 13051901 13052001 13052101 13052201 13052301 13052401 13052501 13052601 13052701 13052801 13052901 13053001 13053101 13060101 13060201 13060301 13060401 13060501 13060601 13060701 13060801 13060901 13061001 13061101 13061201 13061301 13061401 13061501 13061601 13061701 13061801 13061901 13062001 13062101 13062201 13062301 13062401 13062501 13062601 13062701 13062801 13062901 13063001 13070101 13070201 13070301 13070401 13070501 13070601 13070701 13070801 13070901 13071001 13071101 13071201 13071301 13071401 13071501 13071601 13071701 13071801 13071901 13072001 13072101 13072201 13072301 13072401 13072501 13072601 13072701 13072801 13072901 13073001 13073101 13080101 13080201 13080301 13080401 13080501 13080601 13080701 13080801 13080901 13081001 13081101 13081201 13081301 13081401 13081501 13081601 13081701 13081801 13081901 13082001 13082101 13082201 13082301 13082401 13082501 13082601 13082701 13082801 13082901 13083001 13083101 13090101 13090201 13090301 13090401 13090501 13090601 13090701 13090801 13090901 13091001 13091101 13091201 13091301 13091401 13091501 13091601 13091701 13091801 13091901 13092001 13092101 13092201 13092301 13092401 13092501 13092601 13092701 13092801 13092901 13093001 13100101 13100201 13100301 13100401 13100501 13100601 13100701 13100801 13100901 13101001 13101101 13101201 13101301 13101401 13101501 13101601 13101701 13101801 13101901 13102001 13102101 13102201 13102301 13102401 13102501 13102601 13102701 13102801 13102901 13103001 13103101 13110101 13110201 13110301 13110401 13110501 13110601 13110701 13110801 13110901 13111001 13111101 13111201 13111301 13111401 13111501 13111601 13111701 13111801 13111901 13112001 13112101 13112201 13112301 13112401 13112501 13112601 13112701 13112801 13112901 13113001 13120101 13120201 13120301 13120401 13120501 13120601 13120701 13120801 13120901 13121001 13121101 13121201 13121301 13121401 13121501 13121601 13121701 13121801 13121901 13122001 13122101 13122201 13122301 13122401 13122501 13122601 13122701 13122801 13122901 13123001 13123101 14010101 14010201 14010301 14010401 14010501 14010601 14010701 14010801 14010901 14011001 14011101 14011201 14011301 14011401 14011501 14011601 14011701 14011801 14011901 14012001 14012101 14012201 14012301 14012401 14012501 14012601 14012701 14012801 14012901 14013001 14013101 14020101 14020201 14020301 14020401 14020501 14020601 14020701 14020801 14020901 14021001 14021101 14021201 14021301 14021401 14021501 14021601 14021701 14021801 14021901 14022001 14022101 14022201 14022301 14022401 14022501 14022601 14022701 14022801 14030101 14030201 14030301 14030401 14030501 14030601 14030701 14030801 14030901 14031001 14031101 14031201 14031301 14031401 14031501 14031601 14031701 14031801 14031901 14032001 14032101 14032201 14032301 14032401 14032501 14032601 14032701 14032801 14032901 14033001 14033101 14040101 14040201 14040301 14040401 14040501 14040601 14040701 14040801 14040901 14041001 14041101 14041201 14041301 14041401 14041501 14041601 14041701 14041801 14041901 14042001 14042101 14042201 14042301 14042401 14042501 14042601 14042701 14042801 14042901 14043001 14050101 14050201 14050301 14050401 14050501 14050601 14050701 14050801 14050901 14051001 14051101 14051201 14051301 14051401 14051501 14051601 14051701 14051801 14051901 14052001 14052101 14052201 14052301 14052401 14052501 14052601 14052701 14052801 14052901 14053001 14053101! 

page_number = 0..2

$match_expression = %r!<td class="rank"><a href="\.\./history/\?date=\d{8}&cat=book&asin=(\w{10})" class="rank" title="(.+?)">(\d+?)</a></td>!
$unmatch_expression = %r!<td class="rank"><a href="\.\./help/#(rank)" class="rank" title="(.+?)">(.+?)</a></td>!

# 結果をファイル保存　配列を受け取って、一行に一本のリストとして保存
def hozon(hairetsu)
      output_filename = "amaran_kekka.txt" #検索結果を保存するファイル名を指定
      open(output_filename, "a") do |op| #検索結果を保存する
          op.puts(hairetsu.join("\n"))
      end
      p "検索結果をファイルに保存しました"
end
  

# 解析ルーチン
def kaiseki(doc, date)
    seikai = []
    fuseikai = []
    results = []
    ichihon_result = []
    seikai = doc.scan($match_expression)
    p seikai.length
    seikai.each do |s|
        ichihon_result = []
        ichihon_result[3] = s[0] #ASIN
        ichihon_result[2] = s[1] #TITLE
        ichihon_result[1] = s[2] #RANK
        ichihon_result[0] = date
        # p ichihon_result
        results << ichihon_result.join("\t")
    end
    fuseikai = doc.scan($unmatch_expression)
    p fuseikai.length
    fuseikai.each do |s|
        ichihon_result = []
        ichihon_result[3] = "ASIN_UNKNOWN" #ASIN
        ichihon_result[2] = "TITLE_UNKNOWN" #TITLE
        ichihon_result[1] = s[2] #RANK
        ichihon_result[0] = date
        results << ichihon_result.join("\t")
    end
    # p results
    return results
end

# 処理本体
target_date.each do |date|
    result_per_page =[]
    
    date_number = date.to_s
    bunkatsu_year = date.slice(/^\d\d?/)
    bunkatsu_month = date.slice(/\d\d(\d\d)/, 1)
    bunkatsu_date = date.slice(/\d\d\d\d(\d\d)/, 1)
    puts("20#{bunkatsu_year}年の#{bunkatsu_month}月#{bunkatsu_date}日の処理を開始します")
  
  page_number.each do |page|
    page_no = (page + 1).to_s
    puts("#{page_no}ページ目の解析を開始します。")
    complete_url = base_url + "?date=" + date_number + "&cat=book&page=" + page.to_s
    doc = open(complete_url).read
    # p doc
    kekka = kaiseki(doc, date_number)
    # p kekka
    result_per_page << kekka
    puts("#{page_no}ページ目の解析を終了しました。")
    # result_per_page
  end
  hozon(result_per_page)
end

# 終了
