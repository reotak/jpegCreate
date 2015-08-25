# coding: sjis

## この実行ファイルの直下にbmp-rubyを配置すること。
## このディレクトリで git clone https://github.com/yoyoichi/bmp-ruby.git すればOK
## yoyoichiさんに感謝します。
require './bmp-ruby/bmp.rb'
require 'optparse'

begin
  # Windowsにはconvertという別なコマンドがあるので、フルパス必須
  # このconvertコマンドはimageMagicの一部
  # ダウンロードはこちらから。
  # http://www.imagemagick.org/script/binary-releases.php
  CONVERT_PATH = "C:\\Program Files\\ImageMagick-6.9.2-Q16\\convert.exe"

  params = ARGV.getopts('x:y:q:o:h').inject({}) { |hash,(k,v)| hash[k.to_sym] = v; hash }

  if params[:h] then
    puts("ruby jpegCreate.rb [options]")
    puts(" -x <num> width(pixel)")
    puts(" -y <num> hegiht(pixel)")
    puts(" -q <num> quality")
    puts(" -o <name> ouputfile name")
    puts(" -h help")
    exit
  end

  # 横幅(pixel)
  x = params[:x]

  # 縦幅(pixel)
  y = params[:y]

  # 出力ファイル名
  output = params[:o]

  # クオリティ
  quality = params[:q]
  
  x = if x
        x
      else
        print "x => "
        gets
      end.chomp.to_i

    y = if y
        y
      else
        print "y => "
        gets
      end.chomp.to_i

  puts("tmp.bmp : (#{x}, #{y})")
  color = 0
  image = BitMap.new(x, y)
  image.clear(color, color, color)
  image.write('tmp.bmp') # BMPファイルを出力

  # 出力ファイル名が指定されてなかったら tmp.jpgとする
  output = output ? output : "tmp.jpg"
  # quality指定されていたら引数に使える形に整形する
  quality = quality ? "-quality #{quality}" : nil

  puts("exec => cmd /c \"\"#{CONVERT_PATH}\" #{quality} tmp.bmp #{output}\"")
  # jpeg変換を実行
  system("cmd /c \"\"#{CONVERT_PATH}\" #{quality} tmp.bmp #{output}\"")
  system('cmd /c del tmp.bmp') # 一時ファイルを削除
end
