# encoding: utf-8
module Util::String
  def self.search_platform_dependent_characters(str)
    regex = "[" +
      "①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳" +
      "ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗" +
      "㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡㍻〝〟№㏍℡㊤" +
      "㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼㍻©®㈷㈰㈪㈫㈬㈭㈮㈯" +
      "㊗㊐㊊㊋㊌㊍㊎㊏㋀㋁㋂㋃㋄㋅㋆㋇㋈㋉㋊㋋" +
      "㏠㏡㏢㏣㏤㏥㏦㏧㏨㏩㏪㏫㏬㏭㏮㏯㏰㏱㏲㏳" +
      "㏴㏵㏶㏷㏸㏹㏺㏻㏼㏽㏾↔↕↖↗↘↙⇒⇔⇐⇑⇓⇕⇖⇗⇘⇙" +
      "㋐㋑㋒㋓㋔㋕㋖㋗㋘㋙㊑㊒㊓㊔㊕㊟㊚㊛㊜㊣" +
      "㊡㊢㊫㊬㊭㊮㊯㊰㊞㊖㊩㊝㊘㊙㊪㈳㈴㈵㈶㈸" +
      "㈺㈻㈼㈽㈾㈿►☺◄☻‼㎀㎁㎂㎃㎄㎈㎉㎊㎋㎌㎍" +
      "㎑㎒㎓ⅰⅱⅲⅳⅴⅵⅶⅷⅸⅹ〠♠♣♥♤♧♡￤＇＂" +
      "]"
    
    chars = []
    if str =~ /#{regex}/
      str.scan(/#{regex}/).each do |c|
        chars << c
      end
    end
    
    chars.size == 0 ? nil : chars.uniq.join('')
  end
  
  def self.text_to_html(text)
    rslt = ''
    text.each_line do |line|
      line.chop!
      line.gsub!(/(\s+)\s/) do |m|
        '&nbsp;' * m.length
      end
      line << '&nbsp;' if line.blank?
      rslt << %Q(<div>#{line}</div>\n)
    end
    rslt
  end
  
end