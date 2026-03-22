DIR_SRCS := $(ROOT)/$(DIR_SRCS)
DIR_OUT  := $(ROOT)/$(DIR_OUT)
DIR_TMP  := $(ROOT)/$(DIR_TMP)

TPL_MAIN    := $(DIR_SRCS)/templates/skeleton.html.tpl
TPL_TOCPAGE := $(DIR_SRCS)/templates/tocpage.html.tpl
TPL_NAVBAR  := $(DIR_SRCS)/templates/navbar.html.tpl
TPL_CRUMBS  := $(DIR_SRCS)/templates/$(TPLNAME_CRUMBS)

RELPATH  := $(subst $(abspath $(DIR_TMP)),,$(CURDIR))
DIR_INPUTS := $(DIR_SRCS)/content/$(RELPATH)

DIRS      := $(wildcard $(DIR_INPUTS)/*/)
SRCS_HTML := $(wildcard $(DIR_INPUTS)/*.html)
SRCS_TOC  := $(wildcard $(DIR_INPUTS)/*.lua)

OUTDIRS   := $(patsubst $(DIR_INPUTS)/%, %, $(DIRS) )

RECURSE   := $(addsuffix dummy, $(OUTDIRS))
MKFILES   := $(addsuffix Makefile, $(OUTDIRS))
BCRUMBS   := $(addsuffix $(TPLNAME_CRUMBS), $(OUTDIRS))
PAGES     := $(patsubst $(DIR_INPUTS)/%, $(DIR_OUT)/%, $(SRCS_HTML) )
TOCPAGES  := $(patsubst $(DIR_INPUTS)/%.lua, $(DIR_OUT)/%.html, $(SRCS_TOC) )

all : $(TOCPAGES) $(PAGES) $(BCRUMBS) $(MKFILES) $(RECURSE)

$(MKFILES) $(BCRUMBS) $(RECURSE) : | $(OUTDIRS)

$(MKFILES) : %/Makefile : Makefile
	@cp $< $@

$(PAGES): $(DIR_OUT)/%.html : $(TPL_MAIN) $(DIR_INPUTS)/%.html $(TPLNAME_CRUMBS)
	$(htmlgen) $^ -a '{main=1,content={i=2,envfield="content"},bcrumbs=3}' -s $* -o $@

$(TOCPAGES) : $(DIR_OUT)/%.html : $(TPL_MAIN) $(TPL_TOCPAGE) %/$(TPLNAME_CRUMBS) $(DIR_INPUTS)/%.lua
	$(htmlgen) $^ -a '{main=1,content={i=2,envfield="content"},bcrumbs=3,toc=4}' -s $* -o $@

$(BCRUMBS) : %/$(TPLNAME_CRUMBS) : $(TPLNAME_CRUMBS) $(TPL_NAVBAR) $(DIR_INPUTS)/%.lua
	$(htmlgen) $^ -a '{main=1,content={i=2,envfield="navbar"},toc=3}' -s $* -o $@

$(RECURSE) : %/dummy : %/Makefile %/$(TPLNAME_CRUMBS)
	$(MAKE) -C $*

$(OUTDIRS) :
	@install -d $@

debug:
	@echo $(TPL_MAIN) $(DIR_INPUTS)

.PHONY : $(RECURSE) debug

