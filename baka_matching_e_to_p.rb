#!/User/bin/ruby
# coding:utf-8

# Amazonランキング紙本と電子本のマッチングプログラム
# 冒頭の第二のスペースより前の文字でマッチングする
# 
# 抜き出し用正規表現
$nuku = /^\d{8}\t\d+?\t(.+?)\t\w{10}$/

#出力

def output(hairetsu_desu, file_name) #配列をタブ飛ばしでファイルに保存。管理番号（タブ）検索した書名（タブ）検索結果（タブ）著者名（タブ）出版社名（タブ）ISBNの順番に5項目を想定
    output_filename = file_name + ".txt" #検索結果を保存するファイル名を指定
    open(output_filename, "w") do |op| #検索結果を保存する
        op.puts(hairetsu_desu.join("\n"))
    end
    p "検索結果をファイルに保存しました"
end

#入力
def input(file)
   # 元ファイルから一行ずつ読み込んで配列にする。（時刻、順位、書名、ASINの順に入っているので、そこから書名を取り出す）
	hairetsu = []
	open(file, "r") do |io|
		io.readlines.each do |r|
            # nukidashi = r.slice($nuku, 1)
            # nukidashi2 = nukidashi.slice(/^(.+?)[　| ].+$/)
            hairetsu << r.rstrip!
		end
	end
	p "ファイルから書名一覧（#{hairetsu.length}冊分）を読み込み完了"
	return hairetsu
end

# 処理本体

file1 = "sagyo_Amaran_kekka_ebook_20140624.txt"
file2 = "sagyo_Amaran_kekka_pbook_20140624.txt"

puts "これから電子書籍を読み込みます"
ebook_file = input(file1)
puts "これから紙書籍を読み込みます"
pbook_file = input(file2)


kyotsu = ebook_file & pbook_file
kyotsu_number = kyotsu.length
sabun = ebook_file - pbook_file
sabun_number = sabun.length

output(kyotsu, "kyotsu")
output(sabun, "sabun")

puts "共通部分をチェックします。"
print "共通する本は、", kyotsu_number, "タイトルあります。"
puts "差分をチェックします。"
print("電子書籍にしかない本は", sabun_number, "タイトルあります。")

# 終了
