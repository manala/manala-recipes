#########
# Vault #
#########

define vault_login
	$(call message, Vault login)
	read -p "Username: " USERNAME; \
		vault login -method=userpass username=$${USERNAME}
endef
