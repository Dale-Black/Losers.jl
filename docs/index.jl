### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> title = "ComputerVisionMetrics"
#> sidebar = "false"

using Markdown
using InteractiveUtils

# ╔═╡ 487ea05f-75d6-49b3-9845-73d29d6b0495
using HypertextLiteral

# ╔═╡ de44e159-3a61-440d-8db1-0004be55ef97
html"""
<head>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Alegreya+Sans:ital,wght@0,400;0,700;1,400&family=Vollkorn:ital,wght@0,400;0,700;1,400;1,700&display=swap" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/daisyui@3.7.4/dist/full.css" rel="stylesheet" type="text/css" />
	<script src="https://cdn.tailwindcss.com"></script>
</head>

<div data-theme="pastel" class="bg-transparent dark:bg-[#1f1f1f]">
	<div id="ComputerVisionMetricsHeader" class="flex justify-center items-center">
		<div class="card card-bordered border-accent text-center w-full">
			<div class="card-body flex flex-col justify-center items-center">
				<svg width="150px" height="150px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><g data-name="16_weight_loss"><path d="M339 219.93s-38.16-53-22.87-94.22l13-31.11c-104.33-35.84-196.45 0-196.45 0L145.1 123s15.39 43.08-23.84 99.44S90.45 354 105.91 458.46h103.35s16.11-85.88 14.45-113.46h15.75s8.3 96.25 14.44 113.43h101.83S395.88 303.5 339 219.93z" style="fill:#dcd3d4"/><path d="M185.21 117.73s15.38 43.76-23.84 101-30.81 133.7-15.37 239.82h103.37s16.11-87.24 14.44-115.23h15.76s8.3 97.78 14.44 115.23h101.83S436 301.14 379.07 216.24c0 0-38.16-53.84-22.88-95.7 0 0-76.59-27.08-170.98-2.81z" style="fill:#f3b5af"/><path d="M136.27 286.13S240.63 276 267.05 343.32l-17.68 115.23h-20.56S263.81 298 133.1 311zM408 286.12S303.63 276 277.2 343.31l17.68 115.23h20.56S280.44 298 411.15 311z" style="fill:#e08476"/><path d="M172.7 88.93s92.13-36.41 196.45 0l-13 31.61s-71.93-26.42-171-2.81z" style="fill:#4966a2"/><path d="M146.83 245.78s138.9 15.88 246.44-1.45c0 0 12 35.71 12.74 44.2 0 0-104.7-15.89-131.28 54.79h-7.68s-28.32-67.73-130.78-57.19c0 0 4.58-31.23 10.56-40.35z" style="fill:#fff"/><path d="M279 188.19a7.68 7.68 0 1 1-7.67-7.67 7.67 7.67 0 0 1 7.67 7.67z" style="fill:#122546"/><path d="M371.41 190.91a100.18 100.18 0 0 1-8-18.83c14.65-2.29 26.94-5.14 35.84-8.33 4.89-1.75 19.76-7.07 19.76-17.7s-14.93-16-19.83-17.72c-9.07-3.24-21.63-6.13-36.63-8.44a101.25 101.25 0 0 1 11.64-27.68l23-33.2-9.86-6.84-20.55 29.64a312.12 312.12 0 0 0-36.39-9.46l-2.3 11.78a299.13 299.13 0 0 1 32.21 8.2 114.06 114.06 0 0 0-8 19.67c-72.49-17.15-143.27-5.29-163.13-1.27a116.21 116.21 0 0 0-7.59-18.41A297 297 0 0 1 306 80.65l1.42-11.92a312.37 312.37 0 0 0-38.56-2.15 308.72 308.72 0 0 0-93.7 15.23c-5.7-8.37-19.06-28-20.09-29.55l-10 6.66c1.33 2 21.59 31.75 22.68 33.35a98.41 98.41 0 0 1 11.52 27.39c-15.73 2.37-28.89 5.37-38.25 8.73-4.84 1.75-19.6 7.06-19.6 17.64s15 16 19.87 17.75c9.17 3.26 21.91 6.18 37.11 8.5a100.9 100.9 0 0 1-7.94 18.61c-2.53 4.59-5.13 9.05-7.89 13.76-25.39 43.47-54.16 92.73-22.43 255l11.78-2.3c-15.06-77-16.21-127.65-10.62-164.19 11.73-1.4 53.38-4.61 87 15 17.46 10.2 25.66 22.44 29.5 31.29-.42 15.8-1.44 31.76-3 47.46a633.39 633.39 0 0 1-11.22 70.29l11.72 2.56a645.47 645.47 0 0 0 11.44-71.63c1.32-12.9 2.25-26 2.79-39a14.3 14.3 0 0 0 1.75.11h.21a13.84 13.84 0 0 0 2.5-.23c.53 13.06 1.46 26.17 2.79 39.11a643.14 643.14 0 0 0 11.44 71.63l11.72-2.56a635.77 635.77 0 0 1-11.3-70.19 639.466 639.466 0 0 1-3.08-48.73h-.15c4.22-8.74 12.67-20.31 29.51-30 33.22-19.11 74-16.31 85.65-15 5.58 36.49 4.43 87.15-10.57 164.13l11.78 2.3c31.73-162.3 2.95-211.56-22.44-255-2.8-4.7-5.4-9.2-7.93-13.79zm-11.2-59.24c34.4 5.24 45.17 11.84 46.7 14.38-1.52 2.53-12.2 9.1-46.31 14.33a93.24 93.24 0 0 1-.39-28.71zM133.5 146.05c1.55-2.56 12.58-9.32 48.13-14.59a93.48 93.48 0 0 1-.41 29.13C146 155.34 135 148.62 133.5 146.05zM398.34 281c-16-1.37-56-2.36-89.4 16.89-21.38 12.3-31.22 27.57-35.7 38.22a2 2 0 0 1-1.82 1.25h-.21a2 2 0 0 1-1.84-1.18c-4.32-10.65-13.91-25.93-35-38.27-33.81-19.76-74.56-18.47-90.8-17a188.51 188.51 0 0 1 8.33-28.45 1131.14 1131.14 0 0 0 119.3 6.34h.56A1134.19 1134.19 0 0 0 390 252.51a189 189 0 0 1 8.34 28.49zm-126.63-34.2h-.55a1121.35 1121.35 0 0 1-114.45-5.9 337.52 337.52 0 0 1 16.21-30.18c2.67-4.57 5.43-9.3 8-14a110.2 110.2 0 0 0 9.44-22.75c4.92.61 10 1.16 15.31 1.65l1.11-12c-4.72-.44-9.32-.93-13.76-1.47a108.4 108.4 0 0 0-.85-39.8c19.68-3.93 88.4-15.28 157.21 1.1a108.43 108.43 0 0 0-.65 38.54c-10.9 1.34-22.8 2.4-35.18 3.14l11-11-8.49-8.49-25.65 25.65L317.14 198l8.49-8.48-12.38-12.37c13.51-.78 26.27-1.93 38.16-3.43a109.83 109.83 0 0 0 9.49 22.93c2.6 4.73 5.36 9.46 8 14a334.5 334.5 0 0 1 16.24 30.22 1119.5 1119.5 0 0 1-113.43 5.93z" style="fill:#142546"/></g></svg>
				<h1 class="card-title text-5xl font-serif">Losers.jl</h1>
				<p class="card-text text-lg font-serif">Julia Loss Functions for Computer Vision</p>
			</div>
		</div>
	</div>
</div>
"""

# ╔═╡ dea10035-3eb5-41f1-b2cc-694237f5f1f3
struct Article
	title::String
	path::String
	image_url::String
end

# ╔═╡ ef1d1605-0725-473f-9967-e087379b9b64
article_list = Article[
	Article("Getting Started", "getting_started.jl", "https://images.unsplash.com/photo-1513542789411-b6a5d4f31634?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2574&q=80"),
	Article("API", "api.jl", "https://images.unsplash.com/photo-1503789146722-cf137a3c0fea?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2562&q=80"),
];

# ╔═╡ c36e45ca-3aab-41ff-8c80-0fb4f9ed9c36
function ArticleTile(article)
	@htl("""
	<a href="$(article.path)" class="card bordered hover:shadow-lg" style="border-color: #ADD8E6;">
		<div class="card-body">
			<h2 class="card-title">$(article.title)</h2>
			<p>Click to open the notebook.</p>
		</div>
		<figure>
			<img src="$(article.image_url)" alt="$(article.title)">
		</figure>
	</a>
	""")
end;

# ╔═╡ 7bc9b327-7b84-4a32-aa4f-07cf36eaac7d
@htl("""
<div class="grid grid-cols-2 gap-4">
	$([ArticleTile(article) for article in article_list])
</div>
""")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "fc304fba520d81fb78ea25b98f5762b4591b1182"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"
"""

# ╔═╡ Cell order:
# ╟─de44e159-3a61-440d-8db1-0004be55ef97
# ╟─7bc9b327-7b84-4a32-aa4f-07cf36eaac7d
# ╟─ef1d1605-0725-473f-9967-e087379b9b64
# ╟─487ea05f-75d6-49b3-9845-73d29d6b0495
# ╟─dea10035-3eb5-41f1-b2cc-694237f5f1f3
# ╟─c36e45ca-3aab-41ff-8c80-0fb4f9ed9c36
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
