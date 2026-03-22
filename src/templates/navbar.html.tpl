@if toc_entries then
<div class="navbar \$(navlevel0)">
@  for _,entry in ipairs(toc_entries) do
@     local class="$(cssclass." .. entry.fname .. ")"
    <a href="$(entry.fname).html" class="$(class) crossref">$(entry.title)</a>
@  end
</div>
\${navbar}
@end
