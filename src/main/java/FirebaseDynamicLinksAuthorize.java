import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Collections;

public class FirebaseDynamicLinksAuthorize {

    public static void main(String[] args) {
        try {
            System.out.println(getAuthToken());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static String getAuthToken() throws IOException {
        // Load the service account key JSON file
        FileInputStream serviceAccount = new FileInputStream("firebase-account-key.json");

        // Authenticate a Google credential with the service account
        GoogleCredential googleCred = GoogleCredential.fromStream(serviceAccount);

        // Add the required scope to the Google credential
        GoogleCredential scoped = googleCred.createScoped(
                Collections.singletonList(
                        "https://www.googleapis.com/auth/firebase"
                )
        );

        // Use the Google credential to generate an access token
        scoped.refreshToken();
        return scoped.getAccessToken();
        // Include the access token in the Authorization header.
    }
}
