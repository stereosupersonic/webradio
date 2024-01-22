class TrackSanitizer < BaseService
  UNWANTED_TEXT = ["Neu:", "(Album Version)", "(Edit)"]

  attr_accessor :text

  def call
    normalize(text)
  end

  private

  def normalize(text)
    text = CGI.unescapeHTML(text.to_s)
    text = force_convert_to_utf8 text
    remove_unwanted(text).squish.titleize
  end

  def force_convert_to_utf8(text)
    begin
      if text.encoding.to_s == "UTF-8" && text.valid_encoding?
        return text
      end

      str = text.dup.force_encoding("binary").encode(
        "utf-8",
        invalid: :replace,
        undef: :replace,
        replace: "?"
      )

      if !str.valid_encoding? || str.encoding.to_s != "UTF-8"
        raise Encoding::UndefinedConversionError
      end
    rescue Encoding::UndefinedConversionError
      str = chars.map { |c|
        begin
          c.encode("UTF-8", invalid: :replace, undef: :replace)
        rescue
          "?".encode("UTF-8")
        end
      }.join

      if !str.valid_encoding?
        Rollbar.error(e, encoding: text.encoding, text_utf8: text.force_encoding("UTF-8"))
        Rails.logger.error e
      end
    end

    str
  end

  def remove_unwanted(text)
    result = text.gsub(/\|.*/i, "") # remove everyting starts with | like '| Fm4 Homebase'
      .gsub(/Rock Antenne/i, "") # special rock antenne intros
      .gsub(/Rock Nonstop/i, "")
      .gsub("Nachrichten", "")
      .gsub(/Www\.Radiocaroline\.Co\.Uk.\(.*\)/i, "")

    UNWANTED_TEXT.each do |unwanted|
      result.gsub! unwanted, ""
    end
    result
  end

  def fix_encoding(text)
    {
      "Ã€" => "À",
      "Ãƒ" => "Ã",
      "Ã„" => "Ä",
      "Ã…" => "Å",
      "Ã†" => "Æ",
      "Ã‡" => "Ç",
      "Ãˆ" => "È",
      "Ã‰" => "É",
      "ÃŠ" => "Ê",
      "Ã‹" => "Ë",
      "ÃŒ" => "Ì",
      "ÃŽ" => "Î",
      "Ã‘" => "Ñ",
      "Ã’" => "Ò",
      "Ã“" => "Ó",
      "Ã”" => "Ô",
      "Ã•" => "Õ",
      "Ã–" => "Ö",
      "Ã—" => "×",
      "Ã˜" => "Ø",
      "Ã™" => "Ù",
      "Ãš" => "Ú",
      "Ã›" => "Û",
      "Ãœ" => "Ü",
      "Ãž" => "Þ",
      "ÃŸ" => "ß",
      "Ã¡" => "á",
      "Ã¢" => "â",
      "Ã£" => "ã",
      "Ã¤" => "ä",
      "Ã¥" => "å",
      "Ã¦" => "æ",
      "Ã§" => "ç",
      "Ã¨" => "è",
      "Ã©" => "é",
      "Ãª" => "ê",
      "Ã«" => "ë",
      "Ã¬" => "ì",
      "Ã­" => "í",
      "Ã®" => "î",
      "Ã¯" => "ï",
      "Ã°" => "ð",
      "Ã±" => "ñ",
      "Ã²" => "ò",
      "Ã³" => "ó",
      "Ã´" => "ô",
      "Ãµ" => "õ",
      "Ã¶" => "ö",
      "Ã·" => "÷",
      "Ã¸" => "ø",
      "Ã¹" => "ù",
      "Ãº" => "ú",
      "Ã»" => "û",
      "Ã¼" => "ü",
      "Ã½" => "ý",
      "Ã¾" => "þ",
      "Ã¿" => "ÿ"
    }.each do |from, to|
      text = text.gsub(/#{from}/i, to)
    end
    text
  end
end
