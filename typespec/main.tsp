import "@typespec/http";

using TypeSpec.Http;

@service({
  title: "Sharetribe Authentication",
})
@server("https://flex-api.sharetribe.com/v1/auth", "Server")
namespace Authentication;

namespace Token {
  model AnonymousAccessToken {
    client_id: string;
    grant_type: "client_credentials";
    scope: "public-read";
  }

  model UserAccessTokenPasswordGrant {
    client_id: string;
    grant_type: "password";
    username: string;
    password: string;
    scope: "user";
  }

  model UserAccessTokenRefreshTokenGrant {
    client_id: string;
    grant_type: "refresh_token";
    refresh_token: string;
    scope: "user";
  }

  model TrustedUserAccessToken {
    client_id: string;
    client_secret: string;
    subject_token: string;
    grant_type: "token_exchange";
    scope: "trusted:user";
  }

  model IntegrationAccessTokenClientCredentialsGrant {
    client_id: string;
    grant_type: "client_credentials";
    client_secret: string;
    scope: "integ";
  }

  model IntegrationAccessTokenRefreshTokenGrant {
    client_id: string;
    grant_type: "refresh_token";
    refresh_token: string;
    scope: "integ";
  }

  alias IssueTokenFormData =
    | AnonymousAccessToken
    | UserAccessTokenPasswordGrant
    | UserAccessTokenRefreshTokenGrant
    | TrustedUserAccessToken
    | IntegrationAccessTokenClientCredentialsGrant
    | IntegrationAccessTokenRefreshTokenGrant;

  @route("/token")
  @post
  op issueToken(
    @header contentType: "application/x-www-form-urlencoded; charset=utf-8",
    @header accept: "application/json",
    @body formData: IssueTokenFormData,
  ): OkResponse;

  @route("/token")
  @get
  op getDetails(
    @header accept: "application/json",
    @header authorization: string,
  ): OkResponse;

  // @route("/revoke")
  // @post
  // op revokeRefreshToken(): OkResponse;
}
