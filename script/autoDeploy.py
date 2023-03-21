import asyncio
import subprocess


async def run_command(cmd):
    process = await asyncio.create_subprocess_shell(
        cmd, stdout=asyncio.subprocess.PIPE, stderr=asyncio.subprocess.PIPE
    )
    stdout, stderr = await process.communicate()
    if len(stdout) != 0:
        print(f"Success: {stdout.decode()}")
    elif len(stderr) != 0:
        print(f"Error: {stderr.decode()}")
    else:
        pass

    return stdout, stderr


async def main():
    print("Start to compile\t")
    await run_command("solcjs --base-path ./  ../contracts/DataUsageContract.sol --abi --bin -o build")
    await run_command("solcjs --base-path ./  ../contracts/AgreementContract.sol --abi --bin -o build")
    await run_command("solcjs --base-path ./  ../contracts/LogContract.sol --abi --bin -o build")
    await run_command("solcjs --base-path ./  ../contracts/VerificationContract.sol --abi --bin -o build")
    print("End of compilation\t")
    print("=" * 20)
    print("Start to deploy\t")
    await run_command("node ./DataUsageDeploy.js")
    await run_command("node ./AgreementDeploy.js")
    await run_command("node ./LogContractDeploy.js")
    await run_command("node ./VerificationDeploy.js")
    print("End of compilation")


asyncio.run(main())
