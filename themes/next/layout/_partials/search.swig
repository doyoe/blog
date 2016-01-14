{% if theme.swiftype_key %}
  {% include 'search/swiftype.swig' %}
{% elseif theme.tinysou_Key %}
  {% include 'search/tinysou.swig' %}
  {% elseif theme.baidu_key %}
    {% include 'search/baidu.swig' %}
{% endif %}
