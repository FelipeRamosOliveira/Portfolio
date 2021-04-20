from django.db import models

# Create your models here.

class Aluno(models.Model):
    
    nome=models.CharField(max_length=30)
    rg=models.CharField(max_length=9)

    def __str__(self):
        return self.nome