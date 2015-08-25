# coding: sjis

## ���̎��s�t�@�C���̒�����bmp-ruby��z�u���邱�ƁB
## ���̃f�B���N�g���� git clone https://github.com/yoyoichi/bmp-ruby.git �����OK
## yoyoichi����Ɋ��ӂ��܂��B
require './bmp-ruby/bmp.rb'
require 'optparse'

begin
  # Windows�ɂ�convert�Ƃ����ʂȃR�}���h������̂ŁA�t���p�X�K�{
  # ����convert�R�}���h��imageMagic�̈ꕔ
  # �_�E�����[�h�͂����炩��B
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

  # ����(pixel)
  x = params[:x]

  # �c��(pixel)
  y = params[:y]

  # �o�̓t�@�C����
  output = params[:o]

  # �N�I���e�B
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
  image.write('tmp.bmp') # BMP�t�@�C�����o��

  # �o�̓t�@�C�������w�肳��ĂȂ������� tmp.jpg�Ƃ���
  output = output ? output : "tmp.jpg"
  # quality�w�肳��Ă���������Ɏg����`�ɐ��`����
  quality = quality ? "-quality #{quality}" : nil

  puts("exec => cmd /c \"\"#{CONVERT_PATH}\" #{quality} tmp.bmp #{output}\"")
  # jpeg�ϊ������s
  system("cmd /c \"\"#{CONVERT_PATH}\" #{quality} tmp.bmp #{output}\"")
  system('cmd /c del tmp.bmp') # �ꎞ�t�@�C�����폜
end
