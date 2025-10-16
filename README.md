# GasRefund Vault Smart Contract

A Stacks blockchain smart contract that enables campaign-based gas refund pools, written in Clarity.

## Overview

GasRefund Vault allows users to create and participate in gas refund campaigns. Campaign creators can set up pools with specific parameters, and contributors can receive refunds based on predefined multipliers.

## Features

- **Campaign Management**
  - Create campaigns with customizable parameters
  - Set minimum total requirements
  - Configure multiplier basis points (0-10000)
  - Define campaign deadlines

- **Admin Controls**
  - Protected admin functions
  - Ability to transfer admin rights
  - Campaign oversight capabilities

- **User Features**
  - View campaign details
  - Check contribution status
  - Track refund eligibility

## Technical Details

- **Contract Language**: Clarity 1.0
- **Platform**: Stacks Blockchain
- **Error Codes**:
  - `100`: Unauthorized access
  - `101`: Invalid arguments
  - `102`: Resource not found
  - `103`: Insufficient funds
  - `104`: Already exists/processed
  - `105`: Not due yet
  - `106`: Nothing to process

## Functions

### Admin Functions
```clarity
(set-admin (who principal))
```

### Campaign Functions
```clarity
(create-campaign (min-total uint) (multiplier-bps uint) (deadline uint))
```

### View Functions
```clarity
(get-campaign (campaign-id uint))
(get-contribution (campaign-id uint) (who principal))
(get-next-campaign-id)
```

## Installation

1. Clone the repository
2. Install Clarinet
3. Run tests using `clarinet test`

## Testing

To run the test suite:
```bash
clarinet test
```

## Development Status

- [x] Basic contract structure
- [x] Admin management
- [x] Campaign creation
- [x] View functions
- [ ] Contribution mechanism
- [ ] Withdrawal system
- [ ] Claim functionality
- [ ] Campaign finalization
- [ ] Full test coverage
