// Configuração do datasource remoto (CDN/Storage)
// Disponibiliza URLs por idioma: pt -> verses-pt-BR.json, en -> verses-en-US.json
String remoteVersesUrlFor(String langCode) {
	final code = langCode.toLowerCase();
	if (code.startsWith('pt')) {
		return 'https://storage.googleapis.com/holy-messages/verses/verses-pt-BR.json';
	}
	// default to english
	return 'https://storage.googleapis.com/holy-messages/verses/verses-en-US.json';
}

