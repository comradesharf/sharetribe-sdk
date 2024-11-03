import $createClient, { type ClientOptions } from "openapi-fetch";
import type { operations, paths } from "#schema.d.ts";

export interface CreateClientOptions
	extends Pick<
		ClientOptions,
		| "baseUrl"
		| "credentials"
		| "priority"
		| "mode"
		| "keepalive"
		| "integrity"
		| "fetch"
		| "cache"
	> {
	clientId: string;
}

export function createClient({
	baseUrl = "https://flex-api.sharetribe.com/v1/auth",
	credentials,
	priority,
	mode,
	keepalive,
	integrity,
	fetch,
	cache,
	clientId,
}: CreateClientOptions) {
	const client = $createClient<paths>({
		baseUrl,
		credentials,
		priority,
		mode,
		keepalive,
		integrity,
		fetch,
		cache,
		bodySerializer(body) {
			if (typeof body !== "object") {
				throw new Error("Body must be an object");
			}
			console.log("body", body);
			return new URLSearchParams(body);
		},
	});

	client.use({
		onRequest({ request }) {
			return new Request(request, {
				headers: {
					"content-type": "application/x-www-form-urlencoded; charset=utf-8",
				},
			});
		},
	});

	function issueToken<
		T extends
			operations["Token_issueToken"]["requestBody"]["content"]["application/x-www-form-urlencoded; charset=utf-8"],
	>(body: T extends { client_id: string } ? Omit<T, "client_id"> : T) {
		return client.POST("/token", {
			body: {
				client_id: clientId,
				...body,
			},
			params: {
				header: {
					accept: "application/json",
				},
			},
		});
	}

	function getDetails() {
		return client.GET("/token", {
			params: {
				header: {
					accept: "application/json",
				},
			},
		});
	}

	return {
		issueToken,
		getDetails,
	};
}
