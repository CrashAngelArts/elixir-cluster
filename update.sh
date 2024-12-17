#!/bin/bash

# Definir cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem cor

# Função para imprimir mensagens coloridas
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Verificar se está em um repositório git
if [ ! -d .git ]; then
    print_error "Não é um repositório git"
    exit 1
fi

# Salvar alterações locais (opcional)
print_warning "Salvando possíveis alterações locais..."
git add .

# Perguntar por mensagem de commit
read -p "Mensagem de commit (deixe em branco para 'Update'): " commit_message
if [ -z "$commit_message" ]; then
    commit_message="Update $(date '+%Y-%m-%d %H:%M:%S')"
fi

# Commitar alterações
git commit -m "$commit_message"

# Atualizar repositório
print_status "Buscando atualizações remotas..."
git fetch origin

# Fazer merge ou rebase
read -p "Deseja fazer merge (M) ou rebase (R)? [M/R]: " merge_choice
case $merge_choice in
    [Rr]* )
        print_status "Realizando rebase..."
        git pull --rebase origin main
        ;;
    * )
        print_status "Realizando merge..."
        git pull origin main
        ;;
esac

# Enviar alterações
print_status "Enviando alterações para o repositório remoto..."
git push origin main

# Mostrar status final
print_status "Repositório atualizado com sucesso! 🚀"
git status
