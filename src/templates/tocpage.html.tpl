<tocpage>
@for _,entry in ipairs(toc_entries) do
	<a href="$(entry.fname).html" class="pagemenu-item crossref">
		<div class="pmenu-h">$(entry.title)</div>
        <div class="pmenu-text">
            $(entry.desc)
        </div>
@   if entry.img then
        <img class="pmenu-img" src="$(entry.img)"/>
@   end
	</a>

@end
</tocpage>
