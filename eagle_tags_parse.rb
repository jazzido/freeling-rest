# -*- coding: utf-8 -*-
require 'freeling-analyzer'
module FreelingWeb

  # we need to mark these as optional
  OPTIONAL = { :nombres => [:grado] }

  EAGLE_TAGS = File.open('./eagle_tags_dict.rb', 'r') { |f| eval f.read }

  TAG_REGEXPS = EAGLE_TAGS.reduce({}) { |h, (category, v)|
    reg = v[:components].map { |c| 
            r = "?<#{c[:attribute].to_s}>" + c[:values].map { |a| 
                  a[:code]
                 }.join('|')
            r += ')'    
            r += '?' if !OPTIONAL[category].nil? and OPTIONAL[category].include?(c[:attribute])
            r
          }
    reg = reg.join('(')

    h[category] = Regexp.new '^(' + reg + '$'
    h
  }

  def self.parseTag(tag)
    rv = md = nil
    cat, re = TAG_REGEXPS.find { |cat, re| md = tag.match(re); !md.nil? }
    return nil if md.nil?

    rv = { 
      :categoria => cat,
      :categoria_nombre => EAGLE_TAGS[cat][:components][0][:name]
    }

    rv = EAGLE_TAGS[cat][:components][1..-1].reduce(rv) do |h, c|
      h[c[:attribute]] = c[:values].find { |v| 
        v[:code] == md[c[:attribute].to_s] 
      }
      h
    end

    rv
  end

  def self.parseText(text)
    analyzer = FreeLing::Analyzer.new(text, :language => :es)
    analyzer.tokens.map { |t| 
      t[:parsed_tag] = parseTag t[:tag]
      t
    }
  end
end

require 'pp'
if __FILE__ == $0
#  pt = FreelingWeb.parseTag(ARGV[0])
#  pp pt
  pp FreelingWeb.parseText("Mi amigo Juan Mesa se mesa la barba al lado de la mesa.")

end
