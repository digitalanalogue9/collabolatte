import { Typography, Box, Paper, Alert } from '@mui/material';
import { AppLayout } from '../components/AppLayout';
import { AppHeader } from '../components/AppHeader';
import { AppFooter } from '../components/AppFooter';
import { useEffect, useState } from 'react';

interface UserInfo {
  clientPrincipal: {
    userId: string;
    userRoles: string[];
    claims: Array<{ typ: string; val: string }>;
    identityProvider: string;
    userDetails: string;
  } | null;
  displayName?: string;
  email?: string;
}

/** Deployment verification and authentication status page. */
export function HomePage() {
  const [userInfo, setUserInfo] = useState<UserInfo | null>({
    clientPrincipal: null,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    // Fetch user info from EasyAuth endpoint
    fetch('/.auth/me')
      .then((response) => {
        if (!response.ok) {
          throw new Error('Failed to fetch user info');
        }
        const contentType = response.headers.get('content-type') ?? '';
        if (!contentType.includes('application/json')) {
          throw new Error('Unexpected response format');
        }
        return response.json();
      })
      .then((data) => {
        const principal = data.clientPrincipal;
        if (principal) {
          // Extract display name and email from claims
          const nameClaim = principal.claims?.find(
            (c: { typ: string; val: string }) =>
              c.typ === 'name' ||
              c.typ === 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'
          );
          const emailClaim = principal.claims?.find(
            (c: { typ: string; val: string }) =>
              c.typ === 'email' ||
              c.typ === 'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress' ||
              c.typ === 'preferred_username'
          );

          setUserInfo({
            clientPrincipal: principal,
            displayName: nameClaim?.val || principal.userDetails,
            email: emailClaim?.val,
          });
        } else {
          setUserInfo({ clientPrincipal: null });
        }
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message ?? 'Error loading user info');
        setUserInfo({ clientPrincipal: null });
        setLoading(false);
      });
  }, []);

  const isAuthenticated = userInfo?.clientPrincipal !== null;

  return (
    <AppLayout header={<AppHeader userName={userInfo?.displayName} />} footer={<AppFooter />}>
      <Box sx={{ py: 4 }}>
        {loading && (
          <Alert severity="info" sx={{ mb: 3 }}>
            Loading user info...
          </Alert>
        )}
        {error && (
          <Alert severity="error" sx={{ mb: 3 }}>
            Error loading user info: {error}
          </Alert>
        )}
        <Typography variant="h3" component="h1" gutterBottom sx={{ fontWeight: 300 }}>
          Hello, World! 👋
        </Typography>

        <Typography variant="body1" sx={{ mb: 4, color: 'text.secondary' }}>
          Welcome to Collabolatte. This is a minimal deployment verification page.
        </Typography>

        <Paper elevation={0} sx={{ p: 3, bgcolor: 'grey.50', borderRadius: 2 }}>
          <Typography variant="h6" gutterBottom sx={{ fontWeight: 500 }}>
            Authentication Status
          </Typography>

          {isAuthenticated ? (
            <>
              <Alert severity="success" sx={{ mb: 2 }}>
                ✓ Authenticated via Microsoft Entra ID (EasyAuth)
              </Alert>

              <Box sx={{ mt: 2 }}>
                <Typography variant="body2" color="text.secondary" gutterBottom>
                  <strong>Display Name:</strong> {userInfo?.displayName || 'Not available'}
                </Typography>
                {userInfo?.email && (
                  <Typography variant="body2" color="text.secondary" gutterBottom>
                    <strong>Email:</strong> {userInfo.email}
                  </Typography>
                )}
                <Typography variant="body2" color="text.secondary" gutterBottom>
                  <strong>User ID:</strong> {userInfo?.clientPrincipal?.userId}
                </Typography>
                <Typography variant="body2" color="text.secondary" gutterBottom>
                  <strong>Identity Provider:</strong> {userInfo?.clientPrincipal?.identityProvider}
                </Typography>
              </Box>
            </>
          ) : (
            <>
              <Alert severity="info" sx={{ mb: 2 }}>
                Not authenticated. You are viewing this page anonymously.
              </Alert>
              <Typography variant="body2" color="text.secondary">
                <a href="/.auth/login/aad">Sign in with Microsoft Entra ID</a>
              </Typography>
            </>
          )}
        </Paper>

        <Paper elevation={0} sx={{ p: 3, bgcolor: 'grey.50', borderRadius: 2, mt: 3 }}>
          <Typography variant="h6" gutterBottom sx={{ fontWeight: 500 }}>
            Deployment Verification
          </Typography>
          <Typography variant="body2" color="text.secondary">
            This page confirms that:
          </Typography>
          <Box component="ul" sx={{ mt: 1, pl: 2 }}>
            <Typography component="li" variant="body2" color="text.secondary">
              React SPA is deployed and running
            </Typography>
            <Typography component="li" variant="body2" color="text.secondary">
              Azure Static Web App hosting is working
            </Typography>
            <Typography component="li" variant="body2" color="text.secondary">
              EasyAuth integration is configured correctly
            </Typography>
            <Typography component="li" variant="body2" color="text.secondary">
              Sage Calm theme components render correctly
            </Typography>
          </Box>
        </Paper>
      </Box>
    </AppLayout>
  );
}
