from django.contrib import admin

from .models import Category, Genre, GenreTitle, Review, Title


admin.site.register(Category)
admin.site.register(Genre)
admin.site.register(Title)
admin.site.register(GenreTitle)
admin.site.register(Review)
