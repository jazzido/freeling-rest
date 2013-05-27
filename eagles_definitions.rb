# -*- coding: utf-8 -*-
require 'nokogiri'
require 'active_support/core_ext'

# parse the EAGLE definitions for spanish published in 
# http://nlp.lsi.upc.edu/freeling/doc/tagsets/tagset-es.html

module EAGLEDefinitions

  def self.string_to_sym(s)
    s.strip
      .downcase
      .mb_chars
      .normalize(:kd).gsub(/[^\x00-\x7F]/,'')
      .gsub(/\s+/, '-')
      .to_sym
  end

  def self.parseDefinitions(html)

    categorias = {}

    zero = { 
      :value => '-',
      :name => 'N/A',
      :code => '0'
    }

    html.each do |h|
      h = Nokogiri::HTML(h)
      trs = h.css('tr')
      catname = string_to_sym(trs.shift.text)
      categorias[catname] = { :components => [] }
      
      trs.shift # skip the header

      subcomponents = {}; pos = nil
      trs.each do |tr|
        tds = tr.css('td')
        if tds.size == 4 # starts a new component

          unless subcomponents.empty?
            subcomponents[:values] << {
              :value => :na,
              :name  => "N/A",
              :code  => '0' * pos.length
            } unless subcomponents[:values].find { |v| v[:code] == '0' * pos.length }
            
            categorias[catname][:components] << subcomponents
          end

          pos = tds[0].text.strip.split('-')

          subcomponents = {
            :attribute      => string_to_sym(tds[1].text),
            :attribute_name => tds[1].text.strip,
            :values => [
                        {
                          :value => string_to_sym(tds[2].text),
                          :name => tds[2].text.strip,
                          :code => tds[3].text.strip
                        }
                       ]
          }

        elsif tds[1].text.strip# != '0'
          subcomponents[:values] << { 
            :value => string_to_sym(tds[0].text),
            :name => tds[0].text.strip,
            :code => tds[1].text.strip
          }
        end
      end

      subcomponents[:values] << {
        :value => :na,
        :name  => "N/A",
        :code  => '0'
      } unless subcomponents[:values].find { |v| v[:code] == '0' }
      categorias[catname][:components] << subcomponents

    end
    categorias
  end

  HTML = [<<-eos ,
    <tr>

			<th colspan="4" width="365">
      <p>ADJETIVOS</p>

			</th>

		</tr>

		<tr>

			<th width="40">
				
      <p>Pos.</p>

			</th>

			<th width="122">
				
      <p>Atributo</p>

			</th>

			<th width="114">
				
      <p>Valor</p>

			</th>

			<th width="68">
				
      <p>Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="40">
				
      <p align="center">1</p>

			</td>

			<td width="122">
				
      <p align="center">Categoría</p>

			</td>

			<td width="114">
				
      <p align="center">Adjetivo</p>

			</td>

			<td width="68">
				
      <p align="center">A</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">2</p>

			</td>

			<td rowspan="3" width="122">
				
      <p align="center">Tipo</p>

			</td>

			<td width="114">
				
      <p align="center">Calificativo</p>

			</td>

			<td width="68">
				
      <p align="center">Q</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Ordinal</p>

			</td>

			<td width="68">
				
      <p align="center">O</p>

			</td>

		</tr>

		<tr>

			<td width="114">
				
      <p align="center">-</p>

			</td>

			<td width="68">
				
      <p align="center">0</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="4" width="40">
				
      <p align="center">3</p>

			</td>

			<td rowspan="4" width="122">
				
      <p align="center">Grado</p>

			</td>

			<td width="114">
				
      <p align="center">-</p>

			</td>

			<td width="68">
				
      <p align="center">0</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Aumentativo</p>

			</td>

			<td width="68">
				
      <p align="center">A</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Diminutivo</p>

			</td>

			<td width="68">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Superlativo</p>

			</td>

			<td width="68">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">4</p>

			</td>

			<td rowspan="3" width="122">
				
      <p align="center">Género</p>

			</td>

			<td width="114">
				
      <p align="center">Masculino</p>

			</td>

			<td width="68">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Femenino</p>

			</td>

			<td width="68">
				
      <p align="center">F</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Común</p>

			</td>

			<td width="68">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">5</p>

			</td>

			<td rowspan="3" width="122">
				
      <p align="center">Número</p>

			</td>

			<td width="114">
				
      <p align="center">Singular</p>

			</td>

			<td width="68">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Plural</p>

			</td>

			<td width="68">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Invariable</p>

			</td>

			<td width="68">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="40">
				
      <p align="center">6</p>

			</td>

			<td rowspan="2" width="122">
				
      <p align="center">Función</p>

			</td>

			<td width="114">
				
      <p align="center">-</p>

			</td>

			<td width="68">
				
      <p align="center">0</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="114">
				
      <p align="center">Participio</p>

			</td>

			<td width="68">
				
      <p align="center">P</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top">
				
      <p align="center">ADVERBIOS</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="11%">
				
      <p align="center">Pos.</p>

			</th>

			<th width="37%">
				
      <p align="center">Atributo</p>

			</th>

			<th width="32%">
				
      <p align="center">Valor</p>

			</th>

			<th width="19%">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="11%">
				
      <p align="center">1</p>

			</td>

			<td width="37%">
				
      <p align="center">Categoría</p>

			</td>

			<td width="32%">
				
      <p align="center">Adverbio</p>

			</td>

			<td width="19%">
				
      <p align="center">R</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="11%">
				
      <p align="center">2</p>

			</td>

			<td rowspan="2" width="37%">
				
      <p align="center">Tipo</p>

			</td>

			<td width="32%">
				
      <p align="center">General</p>

			</td>

			<td width="19%">
				
      <p align="center">G</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Negativo</p>

			</td>

			<td width="19%">
				
      <p align="center">N</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top" width="365">
				
      <p align="center">DETERMINANTES</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="40">
				
      <p align="center">Pos.</p>

			</th>

			<th width="123">
				
      <p align="center">Atributo</p>

			</th>

			<th width="117">
				
      <p align="center">Valor</p>

			</th>

			<th width="64">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="40">
				
      <p align="center">1</p>

			</td>

			<td width="123">
				
      <p align="center">Categoría</p>

			</td>

			<td width="117">
				
      <p align="center">Determinante</p>

			</td>

			<td width="64">
				
      <p align="center">D</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="6" width="40">
				
      <p align="center">2</p>

			</td>

			<td rowspan="6" width="123">
				
      <p align="center">Tipo</p>

			</td>

			<td width="117">
				
      <p align="center">Demostrativo</p>

			</td>

			<td width="64">
				
      <p align="center">D</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Posesivo</p>

			</td>

			<td width="64">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Interrogativo</p>

			</td>

			<td width="64">
				
      <p align="center">T</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Exclamativo</p>

			</td>

			<td width="64">
				
      <p align="center">E</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Indefinido</p>

			</td>

			<td width="64">
				
      <p align="center">I</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Artículo</p>

			</td>

			<td width="64">
				
      <p align="center">A</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">3</p>

			</td>

			<td rowspan="3" width="123">
				
      <p align="center">Persona</p>

			</td>

			<td width="117">
				
      <p align="center">Primera</p>

			</td>

			<td width="64">
				
      <p align="center">1</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Segunda</p>

			</td>

			<td width="64">
				
      <p align="center">2</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Tercera</p>

			</td>

			<td width="64">
				
      <p align="center">3</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="4" width="40">
				
      <p align="center">4</p>

			</td>

			<td rowspan="4" width="123">
				
      <p align="center">Género</p>

			</td>

			<td width="117">
				
      <p align="center">Masculino</p>

			</td>

			<td width="64">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Femenino</p>

			</td>

			<td width="64">
				
      <p align="center">F</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Común</p>

			</td>

			<td width="64">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Neutro</p>

			</td>

			<td width="64">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">5</p>

			</td>

			<td rowspan="3" width="123">
				
      <p align="center">Número</p>

			</td>

			<td width="117">
				
      <p align="center">Singular</p>

			</td>

			<td width="64">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Plural</p>

			</td>

			<td width="64">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Invariable</p>

			</td>

			<td width="64">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="40">
				
      <p align="center">6</p>

			</td>

			<td rowspan="2" width="123">
				
      <p align="center">Poseedor</p>

			</td>

			<td width="117">
				
      <p align="center">Singular</p>

			</td>

			<td width="64">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="117">
				
      <p align="center">Plural</p>

			</td>

			<td width="64">
				
      <p align="center">P</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top" width="365">
				
      <p align="center">NOMBRES</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="40">
				
      <p align="center">Pos.</p>

			</th>

			<th width="127">
				
      <p align="center">Atributo</p>

			</th>

			<th width="111">
				
      <p align="center">Valor</p>

			</th>

			<th width="67">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="40">
				
      <p align="center">1</p>

			</td>

			<td width="127">
				
      <p align="center">Categoría</p>

			</td>

			<td width="111">
				
      <p align="center">Nombre</p>

			</td>

			<td width="67">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="40">
				
      <p align="center">2</p>

			</td>

			<td rowspan="2" width="127">
				
      <p align="center">Tipo</p>

			</td>

			<td width="111">
				
      <p align="center">Común</p>

			</td>

			<td width="67">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Propio</p>

			</td>

			<td width="67">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">3</p>

			</td>

			<td rowspan="3" width="127">
				
      <p align="center">Género</p>

			</td>

			<td width="111">
				
      <p align="center">Masculino</p>

			</td>

			<td width="67">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Femenino</p>

			</td>

			<td width="67">
				
      <p align="center">F</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Común</p>

			</td>

			<td width="67">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">4</p>

			</td>

			<td rowspan="3" width="127">
				
      <p align="center">Número</p>

			</td>

			<td width="111">
				
      <p align="center">Singular</p>

			</td>

			<td width="67">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Plural</p>

			</td>

			<td width="67">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Invariable</p>

			</td>

			<td width="67">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="4" width="40">
				
      <p align="center">5-6</p>

			</td>

			<td rowspan="4" width="127">
				
      <p align="center">Clasificación semántica</p>

			</td>

			<td width="111">
				
      <p align="center">Persona</p>

			</td>

			<td width="67">
				
      <p align="center">SP</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Lugar 
				</p>

			</td>

			<td width="67">
				
      <p align="center">G0</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Organización</p>

			</td>

			<td width="67">
				
      <p align="center">O0</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Otros</p>

			</td>

			<td width="67">
				
      <p align="center">V0</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="40">
				
      <p align="center">7</p>

			</td>

			<td rowspan="2" width="127">
				
      <p align="center">Grado</p>

			</td>

			<td width="111">
				
      <p align="center">Aumentativo</p>

			</td>

			<td width="67">
				
      <p align="center">A</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Diminutivo</p>

			</td>

			<td width="67">
				
      <p align="center">D</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top">
				
      <p align="center">VERBOS</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="11%">
				
      <p align="center">Pos.</p>

			</th>

			<th width="37%">
				
      <p align="center">Atributo</p>

			</th>

			<th width="32%">
				
      <p align="center">Valor</p>

			</th>

			<th width="19%">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="11%">
				
      <p align="center">1</p>

			</td>

			<td width="37%">
				
      <p align="center">Categoría</p>

			</td>

			<td width="32%">
				
      <p align="center">Verbo</p>

			</td>

			<td width="19%">
				
      <p align="center">V</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="11%">
				
      <p align="center">2</p>

			</td>

			<td rowspan="3" width="37%">
				
      <p align="center">Tipo</p>

			</td>

			<td width="32%">
				
      <p align="center">Principal</p>

			</td>

			<td width="19%">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Auxiliar</p>

			</td>

			<td width="19%">
				
      <p align="center">A</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Semiauxiliar</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="6" width="11%">
				
      <p align="center">3</p>

			</td>

			<td rowspan="6" width="37%">
				
      <p align="center">Modo</p>

			</td>

			<td width="32%">
				
      <p align="center">Indicativo</p>

			</td>

			<td width="19%">
				
      <p align="center">I</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Subjuntivo</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Imperativo</p>

			</td>

			<td width="19%">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Infinitivo</p>

			</td>

			<td width="19%">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Gerundio</p>

			</td>

			<td width="19%">
				
      <p align="center">G</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Participio</p>

			</td>

			<td width="19%">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="6" width="11%">
				
      <p align="center">4</p>

			</td>

			<td rowspan="6" width="37%">
				
      <p align="center">Tiempo</p>

			</td>

			<td width="32%">
				
      <p align="center">Presente</p>

			</td>

			<td width="19%">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Imperfecto</p>

			</td>

			<td width="19%">
				
      <p align="center">I</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Futuro</p>

			</td>

			<td width="19%">
				
      <p align="center">F</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Pasado</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Condicional</p>

			</td>

			<td width="19%">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">-</p>

			</td>

			<td width="19%">
				
      <p align="center">0</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="11%">
				
      <p align="center">5</p>

			</td>

			<td rowspan="3" width="37%">
				
      <p align="center">Persona</p>

			</td>

			<td width="32%">
				
      <p align="center">Primera</p>

			</td>

			<td width="19%">
				
      <p align="center">1</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Segunda</p>

			</td>

			<td width="19%">
				
      <p align="center">2</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Tercera</p>

			</td>

			<td width="19%">
				
      <p align="center">3</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="11%">
				
      <p align="center">6</p>

			</td>

			<td rowspan="2" width="37%">
				
      <p align="center">Número</p>

			</td>

			<td width="32%">
				
      <p align="center">Singular</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Plural</p>

			</td>

			<td width="19%">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="11%">
				
      <p align="center">7</p>

			</td>

			<td rowspan="2" width="37%">
				
      <p align="center">Género</p>

			</td>

			<td width="32%">
				
      <p align="center">Masculino</p>

			</td>

			<td width="19%">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Femenino</p>

			</td>

			<td width="19%">
				
      <p align="center">F</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top" width="365">
				
      <p align="center">PRONOMBRES</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="40">
				
      <p align="center">Pos.</p>

			</th>

			<th width="118">
				
      <p align="center">Atributo</p>

			</th>

			<th width="120">
				
      <p align="center">Valor</p>

			</th>

			<th width="67">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="40">
				
      <p align="center">1</p>

			</td>

			<td width="118">
				
      <p align="center">Categoría</p>

			</td>

			<td width="120">
				
      <p align="center">Pronombre</p>

			</td>

			<td width="67">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="7" width="40">
				
      <p align="center">2</p>

			</td>

			<td rowspan="7" width="118">
				
      <p align="center">Tipo</p>

			</td>

			<td width="120">
				
      <p align="center">Personal</p>

			</td>

			<td width="67">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Demostrativo</p>

			</td>

			<td width="67">
				
      <p align="center">D</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Posesivo</p>

			</td>

			<td width="67">
				
      <p align="center">X</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Indefinido</p>

			</td>

			<td width="67">
				
      <p align="center">I</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Interrogativo</p>

			</td>

			<td width="67">
				
      <p align="center">T</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Relativo</p>

			</td>

			<td width="67">
				
      <p align="center">R</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Exclamativo</p>

			</td>

			<td width="67">
				
      <p align="center">E</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">3</p>

			</td>

			<td rowspan="3" width="118">
				
      <p align="center">Persona</p>

			</td>

			<td width="120">
				
      <p align="center">Primera</p>

			</td>

			<td width="67">
				
      <p align="center">1</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Segunda</p>

			</td>

			<td width="67">
				
      <p align="center">2</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Tercera</p>

			</td>

			<td width="67">
				
      <p align="center">3</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="4" width="40">
				
      <p align="center">4</p>

			</td>

			<td rowspan="4" width="118">
				
      <p align="center">Género</p>

			</td>

			<td width="120">
				
      <p align="center">Masculino</p>

			</td>

			<td width="67">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Femenino</p>

			</td>

			<td width="67">
				
      <p align="center">F</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Común</p>

			</td>

			<td width="67">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Neutro</p>

			</td>

			<td width="67">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="3" width="40">
				
      <p align="center">5</p>

			</td>

			<td rowspan="3" width="118">
				
      <p align="center">Número</p>

			</td>

			<td width="120">
				
      <p align="center">Singular</p>

			</td>

			<td width="67">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Plural</p>

			</td>

			<td width="67">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">ImpersonalMInvariable</p>

			</td>

			<td width="67">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="4" width="40">
				
      <p align="center">6</p>

			</td>

			<td rowspan="4" width="118">
				
      <p align="center">Caso</p>

			</td>

			<td width="120">
				
      <p align="center">Nominativo</p>

			</td>

			<td width="67">
				
      <p align="center">N</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Acusativo</p>

			</td>

			<td width="67">
				
      <p align="center">A</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Dativo</p>

			</td>

			<td width="67">
				
      <p align="center">D</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Oblicuo</p>

			</td>

			<td width="67">
				
      <p align="center">O</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="40">
				
      <p align="center">7</p>

			</td>

			<td rowspan="2" width="118">
				
      <p align="center">Poseedor</p>

			</td>

			<td width="120">
				
      <p align="center">Singular</p>

			</td>

			<td width="67">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="120">
				
      <p align="center">Plural</p>

			</td>

			<td width="67">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="40">
				
      <p align="center">8</p>

			</td>

			<td width="118">
				
      <p align="center">Politeness</p>

			</td>

			<td width="120">
				
      <p align="center">Polite</p>

			</td>

			<td width="67">
				
      <p align="center">P</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top">
				
      <p align="center">CONJUNCIONES</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="12%">
				
      <p align="center">Pos.</p>

			</th>

			<th width="37%">
				
      <p align="center">Atributo</p>

			</th>

			<th width="32%">
				
      <p align="center">Valor</p>

			</th>

			<th width="19%">
				
      <p align="center">Código&gt;</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">1</p>

			</td>

			<td width="37%">
				
      <p align="center">Categoría</p>

			</td>

			<td width="32%">
				
      <p align="center">Conjunción</p>

			</td>

			<td width="19%">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="12%">
				
      <p align="center">2</p>

			</td>

			<td rowspan="2" width="37%">
				
      <p align="center">Tipo</p>

			</td>

			<td width="32%">
				
      <p align="center">Coordinada</p>

			</td>

			<td width="19%">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Subordinada</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top">
				
      <p align="center">INTERJECCIONES</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="12%">
				
      <p align="center">Pos.</p>

			</th>

			<th width="37%">
				
      <p align="center">Atributo</p>

			</th>

			<th width="32%">
				
      <p align="center">Valor</p>

			</th>

			<th width="19%">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">1</p>

			</td>

			<td width="37%">
				
      <p align="center">Categoría</p>

			</td>

			<td width="32%">
				
      <p align="center">Interjección</p>

			</td>

			<td width="19%">
				
      <p align="center">I</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top">
				
      <p align="center">PREPOSICIONES</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="12%">
				
      <p align="center">Pos.</p>

			</th>

			<th width="37%">
				
      <p align="center">Atributo</p>

			</th>

			<th width="32%">
				
      <p align="center">Valor</p>

			</th>

			<th width="19%">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">1</p>

			</td>

			<td width="37%">
				
      <p align="center">Categoría</p>

			</td>

			<td width="32%">
				
      <p align="center">Adposición</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">2</p>

			</td>

			<td width="37%">
				
      <p align="center">Tipo</p>

			</td>

			<td width="32%">
				
      <p align="center">Preposición</p>

			</td>

			<td width="19%">
				
      <p align="center">P</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="2" width="12%">
				
      <p align="center">3</p>

			</td>

			<td rowspan="2" width="37%">
				
      <p align="center">Forma</p>

			</td>

			<td width="32%">
				
      <p align="center">Simple</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="32%">
				
      <p align="center">Contraída</p>

			</td>

			<td width="19%">
				
      <p align="center">C</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">3</p>

			</td>

			<td width="37%">
				
      <p align="center">Género</p>

			</td>

			<td width="32%">
				
      <p align="center">Masculino</p>

			</td>

			<td width="19%">
				
      <p align="center">M</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">4</p>

			</td>

			<td width="37%">
				
      <p align="center">Número</p>

			</td>

			<td width="32%">
				
      <p align="center">Singular</p>

			</td>

			<td width="19%">
				
      <p align="center">S</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top">
				
      <p align="center">SIGNOS DE PUNTUACIÓN</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="12%">
				
      <p align="center">Pos.</p>

			</th>

			<th width="37%">
				
      <p align="center">Atributo</p>

			</th>

			<th width="32%">
				
      <p align="center">Valor</p>

			</th>

			<th width="19%">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">1</p>

			</td>

			<td width="37%">
				
      <p align="center">Categoría</p>

			</td>

			<td width="32%">
				
      <p align="center">Puntuación</p>

			</td>

			<td width="19%">
				
      <p align="center">F</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top" width="365">
				
      <p align="center">CIFRAS</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="40">
				
      <p align="center">Pos.</p>

			</th>

			<th width="129">
				
      <p align="center">Atributo</p>

			</th>

			<th width="111">
				
      <p align="center">Valor</p>

			</th>

			<th width="64">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="40">
				
      <p align="center">1</p>

			</td>

			<td width="129">
				
      <p align="center">Categoría</p>

			</td>

			<td width="111">
				
      <p align="center">Cifra</p>

			</td>

			<td width="64">
				
      <p align="center">Z</p>

			</td>

		</tr>

		<tr valign="top">

			<td rowspan="4" width="40">
				
      <p align="center">2</p>

			</td>

			<td rowspan="4" width="129">
				
      <p align="center">Tipo</p>

			</td>

			<td width="111">
				
      <p align="center">partitivo</p>

			</td>

			<td width="64">
				
      <p align="center">d</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">Moneda</p>

			</td>

			<td width="64">
				
      <p align="center">m</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">porcentaje</p>

			</td>

			<td width="64">
				
      <p align="center">p</p>

			</td>

		</tr>

		<tr valign="top">

			<td width="111">
				
      <p align="center">unidad</p>

			</td>

			<td width="64">
				
      <p align="center">u</p>

			</td>

		</tr>

	
  

eos
<<-eos ,
    <tr>

			<th colspan="4" bgcolor="#ffffff" valign="top">
				
      <p align="center">FECHAS Y HORAS</p>

			</th>

		</tr>

		<tr valign="top">

			<th width="12%">
				
      <p align="center">Pos.</p>

			</th>

			<th width="37%">
				
      <p align="center">Atributo</p>

			</th>

			<th width="32%">
				
      <p align="center">Valor</p>

			</th>

			<th width="19%">
				
      <p align="center">Código</p>

			</th>

		</tr>

		<tr valign="top">

			<td width="12%">
				
      <p align="center">1</p>

			</td>

			<td width="37%">
				
      <p align="center">Categoría</p>

			</td>

			<td width="32%">
				
      <p align="center">Fecha/Hora</p>

			</td>

			<td width="19%">
				
      <p align="center">W</p>

			</td>

		</tr>

eos
]


end

require 'ruby-debug'
require 'pp'
if __FILE__ == $0
  x = EAGLEDefinitions.parseDefinitions(EAGLEDefinitions::HTML)
  #  debugger
  #  puts x.inspect
#  puts PP.pp(x, $>)
  puts x.inspect
end


