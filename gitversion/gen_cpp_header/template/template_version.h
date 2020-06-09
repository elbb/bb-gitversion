#ifndef VERSION_H_
#define VERSION_H_

#include <string>
namespace version { 
{% for key, value in ver.items() %}
constexpr std::string  {{key}} ("{{value}}");
{% endfor %}
}
#endif
