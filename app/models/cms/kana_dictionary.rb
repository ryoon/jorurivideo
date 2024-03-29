# encoding: utf-8
class Cms::KanaDictionary < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Base::Config
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Sys::Model::Auth::Manager
  
  validates_presence_of :name
  
  before_save :convert_to_dic
  
  def convert_to_dic
    self.ipadic_body = ''
    self.unidic_body = ''
    
    words = self.body.split(/\n/u)
    words.each_with_index do |line, idx|
      next if line.strip == ''
      next if line.slice(0, 1) == '#'
      
      data = line.split(/,/)
      if !data[1] || data[2]
        errors.add_to_base "フォーマットエラー: #{line} (#{idx+1}行目)"
        return false
      end
      word = data[0].strip
      kana = data[1].strip
      kana.gsub!(/([アカサタナハマヤラワガザダバパァャヮ])ー/u, '\1ア')
      kana.gsub!(/([イキシチニヒミリギジヂビピィ])ー/u, '\1イ')
      kana.gsub!(/([ウクスツヌフムルグズヅブプゥュ])ー/u, '\1ウ')
      kana.gsub!(/([エケセテネヘメレゲゼデベペェ])ー/u, '\1エ')
      kana.gsub!(/([オコソトノホモロヲゴゾドボポォョ])ー/u, '\1オ')
      
      ## ipadic
      category = Cms::Lib::Navi::Ruby.check_category(word)
      self.ipadic_body += '(品詞 (' + category + '))' +
        ' ((見出し語 (' + word+ ' 500)) (読み ' + kana + ') (発音 ' + kana + '))' + "\n"
      
      ## unidic
      goshu = '和'
      if word =~ /^[一-龠]+/
        goshu = '漢'
      elsif word =~ /^[Ａ-Ｚ]+/
        goshu = '記号'
      end
      word.tr!("0-9a-zA-Z", "０-９ａ-ｚＡ-Ｚ")
      kana.gsub!(/[^ァ-ン]/, '')
      category = Cms::Lib::Navi::Gtalk.check_category(word)
      self.unidic_body += '(POS (' + category + '))' +
        ' ((LEX (' + word + ' 500)) (READING ' + kana + ') (PRON ' + kana + ')'+
        ' (INFO "lForm=\"' + kana + '\" lemma=\"' + word + '\" orthBase=\"' + word + '\"' +
        ' pronBase=\"' + kana + '\" kanaBase=\"' + kana + '\" formBase=\"' + kana + '\"' +
        ' goshu=\"' + goshu + '\" aType=\"0\" aConType=\"C2\""))' + "\n"
    end
    return true
  end
  
  def self.make_dic_file
    dic_data = {:ipadic => '', :unidic => ''}
    
    self.find(:all).each do |item|
      dic_data[:ipadic] += item.ipadic_body.gsub(/\r\n/, "\n") + "\n"
      dic_data[:unidic] += item.unidic_body.gsub(/\r\n/, "\n") + "\n"
    end
    
    if dic_data[:ipadic] == ''
      dic_data[:ipadic] = '(品詞 (記号 アルファベット)) ((見出し語 (Joruri 500)) (読み ジョウルリ) (発音 ジョウルリ))'
    end
    if dic_data[:unidic] == ''
      dic_data[:unidic] = '(POS (記号 文字))' +
        ' ((LEX (Ｊｏｒｕｒｉ 500)) (READING ジョウルリ) (PRON ジョウルリ)' +
        ' (INFO "lForm=\"ジョウルリ\" lemma=\"Ｊｏｒｕｒｉ\" orthBase=\"Ｊｏｒｕｒｉ\"' +
        ' pronBase=\"ジョウルリ\" kanaBase=\"ジョウルリ\" formBase=\"ジョウルリ\"' +
        ' goshu=\"記号\" aType=\"0\" aConType=\"C2\""))'
    end

    require 'shell'
    
    ## ipadic
    dir = "#{Rails.root}/ext/morph/ipadic"
    tmp = Tempfile::new('/cmsdic', dir)
    tmp.puts(dic_data[:ipadic])
    tmp.close
    
    sh = Shell.cd(dir)
    sh.system("`chasen-config --mkchadic`/makeda -i w #{tmp.path}_dat #{tmp.path}").to_s
    if success = FileTest.exist?(tmp.path + '_dat.da')
      FileUtils.mv(tmp.path + '_dat.da' , dir + '/cmsdic.da')
      FileUtils.mv(tmp.path + '_dat.dat', dir + '/cmsdic.dat')
      FileUtils.mv(tmp.path + '_dat.lex', dir + '/cmsdic.lex')
      FileUtils.mv(tmp.path, dir + '/cmsdic.dic')
    end
    FileUtils.rm(tmp.path + '_dat.da')  if FileTest.exist?(tmp.path + '_dat.da')
    FileUtils.rm(tmp.path + '_dat.dat') if FileTest.exist?(tmp.path + '_dat.dat')
    FileUtils.rm(tmp.path + '_dat.lex') if FileTest.exist?(tmp.path + '_dat.lex')
    FileUtils.rm(tmp.path + '_dat.tmp') if FileTest.exist?(tmp.path + '_dat.tmp')
    FileUtils.rm(tmp.path) if FileTest.exist?(tmp.path)
    return '辞書の作成に失敗しました（ふりがな）' unless success
    
    ## unidic
    dir = "#{Rails.root}/ext/morph/unidic"
    tmp = Tempfile::new('/unidic', dir)
    tmp.puts(dic_data[:unidic])
    tmp.close
    
    sh = Shell.cd(dir)
    sh.system("`chasen-config --mkchadic`/makeda -i w #{tmp.path}_dat #{tmp.path}").to_s
    if success = FileTest.exist?(tmp.path + '_dat.da')
      FileUtils.mv(tmp.path + '_dat.da' , dir + '/cmsdic.da')
      FileUtils.mv(tmp.path + '_dat.dat', dir + '/cmsdic.dat')
      FileUtils.mv(tmp.path + '_dat.lex', dir + '/cmsdic.lex')
      FileUtils.mv(tmp.path, dir + '/cmsdic.dic')
    end
    FileUtils.rm(tmp.path + '_dat.da')  if FileTest.exist?(tmp.path + '_dat.da')
    FileUtils.rm(tmp.path + '_dat.dat') if FileTest.exist?(tmp.path + '_dat.dat')
    FileUtils.rm(tmp.path + '_dat.lex') if FileTest.exist?(tmp.path + '_dat.lex')
    FileUtils.rm(tmp.path + '_dat.tmp') if FileTest.exist?(tmp.path + '_dat.tmp')
    FileUtils.rm(tmp.path) if FileTest.exist?(tmp.path)
    return '辞書の作成に失敗しました（読み上げ）' unless success
    
    return true
  end
end
