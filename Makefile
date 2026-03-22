DIR_SRCS := src
DIR_OUT  := public
DIR_TMP  := .maketmp

htmlgen = lua $(abspath populate.lua)

TPLNAME_CRUMBS := breadcrumbs.html.tpl
export

BSTRAP_TGTS := $(DIR_TMP)/Makefile $(DIR_TMP)/$(TPLNAME_CRUMBS)

targets := $(DIR_OUT)/style.css $(DIR_OUT)/rmodel.html $(BSTRAP_TGTS) recurse

all : $(targets)

$(targets) : | $(DIR_OUT) $(DIR_TMP)


$(DIR_OUT)/style.css : $(DIR_SRCS)/style.css
	@cp $< $@

$(DIR_OUT)/rmodel.html : $(DIR_OUT)/fancy.kindsl.html

$(DIR_OUT)/fancy.kindsl.html : $(DIR_SRCS)/content/docs/fancy.kindsl
	pygmentize -f html -P full=true $< -o $@



$(DIR_TMP)/Makefile : $(DIR_SRCS)/Makefile
$(DIR_TMP)/$(TPLNAME_CRUMBS) : $(DIR_SRCS)/templates/$(TPLNAME_CRUMBS)

$(BSTRAP_TGTS) :
	@cp -f $< $@

recurse: export ROOT := ..
recurse: $(BSTRAP_TGTS)
	$(MAKE) -C $(DIR_TMP)


$(DIR_OUT) $(DIR_TMP):
	@mkdir -p $@


clean :
	rm $(DIR_OUT)/*.html $(DIR_OUT)/*.css
	rm -rf $(DIR_TMP)

debug:
	@echo $(CURDIR)


.PHONY: all clean debug recurse

