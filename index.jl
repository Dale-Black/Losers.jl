### A Pluto.jl notebook ###
# v0.19.36

#> [frontmatter]
#> title = "Home"

using Markdown
using InteractiveUtils

# ╔═╡ 376f724f-9527-4935-9a2d-277736b506c5
# ╠═╡ show_logs = false
begin
	using Pkg
	Pkg.activate(joinpath(pwd(), "docs"))
	Pkg.instantiate()

	using HTMLStrings: to_html, head, link, script, divv, h1, img, p, span, a, figure, hr
	using PlutoUI
end

# ╔═╡ bcd61a1b-cb5a-4790-9cb6-49aa90a0026a
md"""
## Tutorials
"""

# ╔═╡ aa38603a-c229-498b-9f68-35f771c2be3f
md"""
## API
"""

# ╔═╡ 0d0b13c6-13e7-4455-88aa-52ef41e79426
to_html(hr())

# ╔═╡ 87f8a38b-913c-4741-8cfb-9374f9249b1e
TableOfContents()

# ╔═╡ cf085777-a98b-428d-9874-d804f016a848
data_theme = "wireframe";

# ╔═╡ 6206cc69-7734-4c3b-8a49-5540ee14e637
function index_title_card(title::String, subtitle::String, image_url::String; data_theme::String = "pastel", border_color::String = "primary")
	return to_html(
	    divv(
	        head(
				link(:href => "https://cdn.jsdelivr.net/npm/daisyui@3.7.4/dist/full.css", :rel => "stylesheet", :type => "text/css"),
	            script(:src => "https://cdn.tailwindcss.com")
	        ),
			divv(:data_theme => "$data_theme", :class => "card card-bordered flex justify-center items-center border-$border_color text-center w-full dark:text-[#e6e6e6]",
				divv(:class => "card-body flex flex-col justify-center items-center",
					img(:src => "$image_url", :class => "h-24 w-24 md:h-40 md:w-40 rounded-md", :alt => "$title Logo"),
					divv(:class => "text-5xl font-bold bg-gradient-to-r from-accent to-primary inline-block text-transparent bg-clip-text py-10", "$title"),
					p(:class => "card-text text-md font-serif", "$subtitle"
					)
				)
			)
	    )
	)
end;

# ╔═╡ dca441ea-8112-4ff2-9ef5-50f79a6dbae4
index_title_card(
	"Losers.jl",
	"Julia Loss Functions for Computer Vision",
	"https://img.freepik.com/free-vector/low-self-esteem-woman-looking-into-mirror_23-2148714425.jpg?size=626&ext=jpg&ga=GA1.1.1427368820.1695503713&semt=ais";
	data_theme = data_theme
)

# ╔═╡ 7a8d76f3-bb6e-4b3f-9c0f-02c1c3fea843
struct Article
	title::String
	path::String
	image_url::String
end

# ╔═╡ 6b5bbae5-95f4-4d1e-8c3f-03af6a584ebd
article_list_tutorials = Article[
	Article("Getting Started", "docs/01_getting_started.jl", "https://img.freepik.com/free-photo/futuristic-spaceship-takes-off-into-purple-galaxy-fueled-by-innovation-generated-by-ai_24640-100023.jpg"),
];

# ╔═╡ 3b9b9f15-ca74-4f8b-9d13-c3d64c296cac
article_list_api = Article[
	Article("API", "docs/99_api.jl", "https://img.freepik.com/free-photo/modern-technology-workshop-creativity-innovation-communication-development-generated-by-ai_188544-24548.jpg"),
];

# ╔═╡ 7ac4f52d-a3bf-405d-828b-5dbf486039a5
function article_card(article::Article, color::String; data_theme = "pastel")
    a(:href => article.path, :class => "w-1/2 p-2",
		divv(:data_theme => "$data_theme", :class => "card card-bordered border-$color text-center dark:text-[#e6e6e6]",
			divv(:class => "card-body justify-center items-center",
				p(:class => "card-title", article.title),
				p("Click to open the notebook")
			),
			figure(
				img(:src => article.image_url, :alt => article.title)
			)
        )
    )
end;

# ╔═╡ 54ee853d-5faf-4012-89f3-8fdaab23d450
to_html(
    divv(:class => "flex flex-wrap justify-center items-start",
        [article_card(article, "accent"; data_theme = data_theme) for article in article_list_tutorials]...
    )
)

# ╔═╡ c40375e1-0346-4e54-b725-1a95dca0755e
to_html(
    divv(:class => "flex flex-wrap justify-center items-start",
        [article_card(article, "secondary"; data_theme = data_theme) for article in article_list_api]...
    )
)

# ╔═╡ Cell order:
# ╟─dca441ea-8112-4ff2-9ef5-50f79a6dbae4
# ╟─bcd61a1b-cb5a-4790-9cb6-49aa90a0026a
# ╟─54ee853d-5faf-4012-89f3-8fdaab23d450
# ╟─aa38603a-c229-498b-9f68-35f771c2be3f
# ╟─c40375e1-0346-4e54-b725-1a95dca0755e
# ╟─0d0b13c6-13e7-4455-88aa-52ef41e79426
# ╟─87f8a38b-913c-4741-8cfb-9374f9249b1e
# ╟─cf085777-a98b-428d-9874-d804f016a848
# ╟─376f724f-9527-4935-9a2d-277736b506c5
# ╟─6206cc69-7734-4c3b-8a49-5540ee14e637
# ╟─7a8d76f3-bb6e-4b3f-9c0f-02c1c3fea843
# ╟─6b5bbae5-95f4-4d1e-8c3f-03af6a584ebd
# ╟─3b9b9f15-ca74-4f8b-9d13-c3d64c296cac
# ╟─7ac4f52d-a3bf-405d-828b-5dbf486039a5
