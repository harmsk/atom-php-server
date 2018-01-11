module.exports = class PhpProvider

	fromGrammarName: 'PHP'
	fromScopeName: 'text.html.php'
	toScopeName: 'text.html.basic'

	transform: (code, {sourceMap} = {}) ->
		phpCommand = atom.config.get('php-server.phpPath')
		{execSync} = require 'child_process'

		# throws error on non-zero exit or timeout.
		result = execSync(phpCommand, {input: code, env: process.env, timeout: 500} )

		code: result
