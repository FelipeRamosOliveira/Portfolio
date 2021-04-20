from django.contrib import admin
from escola.models import Aluno
# Register your models here.

class Alunos(admin.ModelAdmin):
    list_diplay=('id','nome','rg')
    list_diplay_links=('id','nome')
    serch_fields=('nome')

admin.site.register(Aluno,Alunos)