// Health check endpoint for Kubernetes liveness and readiness probes
import type { NextApiRequest, NextApiResponse } from 'next';

type HealthResponse = {
    status: string;
    timestamp: string;
    uptime: number;
    environment: string;
    version: string;
};

export default function handler(
    req: NextApiRequest,
    res: NextApiResponse<HealthResponse>
) {
    // Only allow GET requests
    if (req.method !== 'GET') {
        res.status(405).json({
            status: 'error',
            timestamp: new Date().toISOString(),
            uptime: process.uptime(),
            environment: process.env.NODE_ENV || 'development',
            version: process.env.npm_package_version || '1.0.0',
        });
        return;
    }

    // Return healthy status
    res.status(200).json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        environment: process.env.NODE_ENV || 'development',
        version: process.env.npm_package_version || '1.0.0',
    });
}
